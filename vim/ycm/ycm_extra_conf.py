import os
import sys
import collections
import logging
import tempfile
import shutil
import stat
from threading import Lock


BASE_FLAGS = [
  '-Wall',
  '-Wno-multichar',
  '-DNDEBUG',
  '-UDEBUG',
  '-Wno-format-pedantic',
  '-ferror-limit=10000',
  '-fexceptions',
  '-DUSE_CLANG_COMPLETER',
]

KERNEL_SRC_FLAGS = [
  '-Wc++98-compat',
  '-D__KERNEL__',
  '-nostdinc',
  '-std=gnu89',
  '-x', 'c',
  '-Iarch/arm64/include',
  '-Iarch/arm64/include/uapi',
  '-Iinclude',
  '-Iinclude/uapi',
]

KERNEL_OUT_FLAGS = [
  '-Iarch/arm64/include/generated/uapi',
  '-Iarch/arm64/include/generated',
  '-Iinclude/generated/uapi',
  '-Iinclude',
]

ANDROID_FLAGS = [
  '-DANDROID',
  '-D__compiler_offsetof=__builtin_offsetof',
  '-std=c++14',
  '-x', 'c++',

  # stdlib replacement
  '-nostdlibinc',
  '-D_USING_LIBCXX',
  '-I external/libcxx/include',
  '-I external/libcxxabi/include',
  '-isystem bionic/libc/include',
  '-isystem bionic/libc/kernel/uapi',
  '-isystem bionic/libc/kernel/android/uapi',

  # assume arm64 arch
  '-isystem bionic/libc/arch-arm64/include',
  '-isystem bionic/libc/kernel/uapi/asm-arm64',

  # core includes
  '-I system/core/base/include',
  '-I system/core/libutils/include',
  '-I system/core/libcutils/include',
  '-I system/core/liblog/include',

  # HIDL includes
  '-I system/libhidl/base/include',
  '-I system/libhidl/transport/include',
  '-I out/soong/.intermediates/system/libhidl/transport/manager/1.0/android.hidl.manager@1.0_genc++_headers/gen',
  '-I out/soong/.intermediates/system/libhidl/transport/base/1.0/android.hidl.base@1.0_genc++_headers/gen',
  '-I system/libhwbinder/include',
  '-I system/libvintf/include',

  # Legacy HAL includes
  '-I system/media/audio/include',
  '-I hardware/libhardware/include',
  '-I hardware/libhardware_legacy/include',
  '-I hardware/ril/include',
  '-I frameworks/native/include',
  '-I frameworks/av/include',

  # other includes
  '-I libnativehelper/include/nativehelper',
]

BL_FLAGS = [
  '-x', 'c',
  '-fshort-wchar',
  '-fno-short-enums',
  '-fno-strict-aliasing'
  '-nostdlibinc',
  '-mlittle-endian',
  '-IInclude',
  '-IInclude/Library',
  '-ISDM845Pkg/Include/Library', # TODO: make this dynamic
  '-IQcomModulePkg/Include/Library', # TODO: make this dynamic
]

PATH_FLAGS = ['-isystem', '-I', '-iquote', '--sysroot=', '-Wp,-MD,']
SOURCE_EXTENSIONS = ['.c', '.cpp', '.cxx', '.cc', '.m', '.mm']
SOURCE_DIRECTORIES = ['.', 'src', 'lib']
HEADER_EXTENSIONS = ['.h', '.hxx', '.hpp', '.hh']
HEADER_DIRECTORIES = ['include']

# folders to stop find at
STOP_AT_DIRS = ['home', 'google3']

# access to this should be protected by the below lock!
_databases = collections.defaultdict( lambda: None )
_databases_lock = Lock()
_ycm_temp_dir = None


def FindInPath(target):
  for dirname in sys.path:
    candidate = os.path.join(dirname, target)
    if os.path.isfile(candidate):
      return candidate
  raise RuntimeError('Could not find path to: ' + target)


def FindNearestDir(path, target, build_folder=None):
  candidate = os.path.join(path, target)
  if os.path.isfile(candidate) or os.path.isdir(candidate):
    logging.info("Found nearest " + target + " at " + path)
    return path

  parent = os.path.dirname(os.path.abspath(path))
  if parent == path or os.path.basename(parent) in STOP_AT_DIRS:
    raise RuntimeError("Could not find " + target)

  if build_folder:
    build_path = os.path.join(parent, build_folder)

    candidate = os.path.join(build_path, target)
    if os.path.isfile(candidate) or os.path.isdir(candidate):
      logging.info(
        "Found nearest " + target + " in build folder at " + build_path)
      return build_path

  return FindNearestDir(parent, target, build_folder)


def FindNearest(path, target, build_folder=None):
  return os.path.join(FindNearestDir(path, target, build_folder), target)

def ProcessFlags(compiler_flags, working_directory):
  flags = list(compiler_flags)
  if not working_directory:
    return flags

  new_flags = []
  make_next_absolute = False

  for flag in flags:
    new_flag = flag

    if flag.startswith('@'):
      path = flag.strip('"@')
      if path.startswith('/'):
        path = os.path.join(working_directory, path)
      if os.path.exists(path):
        with open(path) as fp:
          flags += fp.read().splitlines()
      continue

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith('/'):
        new_flag = os.path.join(working_directory, flag)

    for path_flag in PATH_FLAGS:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith(path_flag):
        path = flag[len(path_flag):]
        new_flag = path_flag + os.path.join(working_directory, path.strip())
        break

    if new_flag:
      new_flags.append(new_flag)
  return new_flags


def IsHeaderFile(filename):
  extension = os.path.splitext(filename)[1]
  return extension in HEADER_EXTENSIONS


def GetCompilationInfoForFile(database, filename):
  compilation_info = database.GetCompilationInfoForFile(filename)
  if compilation_info.compiler_flags_:
    return compilation_info

  # The compilation_commands.json file generated may not have entries for header
  # files. So do our best by asking the db for flags for a corresponding source
  # file, if any. If one exists, the flags for that file should be good enough.
  if IsHeaderFile(filename):
    basename = os.path.splitext(filename)[0]
    for extension in SOURCE_EXTENSIONS:
      # Get info from source files by replacing the extension
      replacement_file = basename + extension
      if os.path.exists(replacement_file):
        compilation_info = database.GetCompilationInfoForFile(replacement_file)
        if compilation_info.compiler_flags_:
          return compilation_info

      # If that wasn't successful, try replacing possible header directory
      # with possible source directories.
      for header_dir in HEADER_DIRECTORIES:
        for source_dir in SOURCE_DIRECTORIES:
          src_file = replacement_file.replace(header_dir, source_dir)
          if os.path.exists(src_file):
            compilation_info = database.GetCompilationInfoForFile(src_file)
            if compilation_info.compiler_flags_:
              return compilation_info
  return None


def GetDatabaseForPath( path ):
  # Can't be top-level because this file is sourced before ycm_core.so is placed
  # in the correct location with YcmCorePreload
  import ycm_core

  global _databases

  with _databases_lock:
    database = _databases[ path ]

  if not database:
    database = ycm_core.CompilationDatabase( path )
    with _databases_lock:
      _databases[ path ] = database

  return database


def FlagsForCompilationDatabase(filename):
  root = os.path.realpath(filename)
  try:
    # Last argument of next function is the name of the build folder for
    # out of source projects

    compilation_db = FindNearest(root, 'compile_commands.json', 'build')
    compilation_db_dir = os.path.dirname(os.path.realpath(compilation_db))
    logging.info(
      "Set compilation database directory to " + compilation_db_dir)
    compilation_db = GetDatabaseForPath(compilation_db_dir)
    if not compilation_db:
      logging.info("Compilation database file found but unable to load")
      return None
    if compilation_db.AlreadyGettingFlags():
      logging.info("Compilation database busy getting flags")
      return None
    compilation_info = GetCompilationInfoForFile(compilation_db, filename)
    if not compilation_info:
      logging.info(
        "No compilation info for " + filename + " in compilation database")
      return None
    return ProcessFlags(
      compilation_info.compiler_flags_,
      compilation_info.compiler_working_dir_)
  except RuntimeError:
    # no compilation database found
    return None


def FlagsForClangComplete(root):
  try:
    path = FindNearest(root, '.clang_complete')
    flags = open(path, 'r').read().splitlines()

    relative_to = os.path.dirname(path)
    clang_complete_flags = ProcessFlags(flags, relative_to)
    return clang_complete_flags
  except RuntimeError:
    # not found
    return None


def FlagsForInclude(root):
  try:
    include_path = FindNearest(root, 'include')
    return ["-I" + include_path]
    # for dirroot, dirnames, filenames in os.walk(include_path):
      # for dir_path in dirnames:
        # real_path = os.path.join(dirroot, dir_path)
        # flags += ["-I" + real_path]
    # return flags
  except RuntimeError:
    # not found
    return None


def FlagsForPath(filename):
  root = os.path.realpath(filename)

  flags = BASE_FLAGS
  # include path as include dir
  clang_flags = FlagsForClangComplete(root)
  if clang_flags:
    flags += clang_flags
  include_flags = FlagsForInclude(root)
  if include_flags:
    flags += include_flags

  return flags


def FlagsForAndroid(filename):
  root = os.path.realpath(filename)
  try:
    android_top = FindNearestDir(root, 'build/core/config.mk')
    logging.info("Found android build at " + android_top)

    flags = FlagsForPath(filename)
    flags += ProcessFlags(ANDROID_FLAGS, android_top)
    return flags
  except RuntimeError:
    # not android build
    return None


def parse_buildconfig(filename):
  if not os.path.exists(filename):
    return None
  config = {}
  with open(filename) as fp:
    for l in fp.readlines():
      tmp = l.split('=', 2)
      if len(tmp) == 2:
        config[tmp[0]] = tmp[1].strip(' \t\n')
  return config


def FlagsForKernelRepo(kernel_top):
  try:
    repo_top = FindNearestDir(kernel_top, 'build/build.config')

    config = parse_buildconfig(os.path.join(repo_top, 'build.config'))
    if not config:
      return None

    flags = []
    if 'LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN' in config:
      bin_path = config['LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN']
      lib = os.path.join(repo_top, os.path.dirname(bin_path), 'lib')

      # find first include folder within cross compiler and add to path
      for dirpath, dirnames, filenames in os.walk(lib):
        if 'include' in dirnames:
          flags += ['-I', os.path.join(dirpath, 'include')]
          break

    if 'BRANCH' in config:
      out_dir = os.path.join(repo_top, 'out', config['BRANCH'])
      if os.path.exists(os.path.join(out_dir, 'vmlinux')):
        flags += ProcessFlags(KERNEL_OUT_FLAGS, out_dir)

    return flags
  except RuntimeError:
    return None


def FlagsForKernel(filename):
  root = os.path.realpath(filename)
  try:
    kernel_top = FindNearestDir(root, '.git')
    if not os.path.exists(os.path.join(kernel_top, 'Kbuild')):
      return None
    logging.info("Found kernel build at " + kernel_top)

    flags = BASE_FLAGS
    flags += ProcessFlags(KERNEL_SRC_FLAGS, kernel_top)
    repo_flags = FlagsForKernelRepo(kernel_top)
    if repo_flags:
      # repo flags are already processed
      flags += repo_flags
    else:
      # assume that kernel is built alongside source
      flags += ProcessFlags(KERNEL_OUT_FLAGS, kernel_top)

    return flags
  except RuntimeError:
    # not android build
    return None

def FlagsForBL(filename):
  root = os.path.realpath(filename)
  try:
    bl_top = FindNearestDir(root, 'QcomPkg.dec')
    if not os.path.exists(os.path.join(bl_top, 'buildex.py')):
      return None
    logging.info("Found bootloader at " + bl_top)

    flags = BASE_FLAGS
    flags += ProcessFlags(BL_FLAGS, bl_top)

    return flags
  except RuntimeError:
    # not android build
    return None


YCM_STRATEGIES = [
  FlagsForCompilationDatabase,
  FlagsForKernel,
  FlagsForAndroid,
  FlagsForBL,
  FlagsForPath,
]

NO_FLAGS = { 'flags': [], 'do_cache': False, 'flags_ready': False }

def FlagsForFile(filename, **kwargs):
  for s in YCM_STRATEGIES:
    flags = s(filename)
    if flags:
      return {
        'flags': flags,
        'do_cache': True
      }

  return NO_FLAGS


def MakeEverythingUnderFolderOwnerAccessible( path_to_folder ):
  for dirpath, dirnames, filenames in os.walk( path_to_folder ):
    for name in filenames + dirnames:
      path = os.path.join( dirpath, name )
      current_stat = os.stat( path )
      # readable, writable and executable by the user
      os.chmod( path, current_stat.st_mode | stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR )


def GetGoogleYcmClang(clang_path):
  clang_includes = os.path.join(clang_path,
                                'clang/google3-trunk/include')
  if not os.path.isdir(clang_includes):
    return None

  return {
    'lib': os.path.join(clang_path, 'libclang.so'),
    'include': clang_includes,
  }


def GetGoogle3Clang():
  try:
    google3_path = FindNearest(os.getcwd(), 'google3')
    if os.path.islink(os.path.join(google3_path, '../READONLY')):
      google3_path = os.path.join(google3_path, '../READONLY/google3')

    crosstool_path = os.path.join(google3_path, 'third_party/crosstool/v18')
    if not os.path.isdir(crosstool_path):
      return None

    clang_path = os.path.join(crosstool_path, 'stable/toolchain/lib')
    clang = GetGoogleYcmClang(clang_path)
    if clang:
      # TODO: YCM_STRATEGIES = Google3 only
      pass

    return clang

  except RuntimeError:
    return None


def GetAndroidClang(ycmd_path):
  try:
    cwd = os.getcwd()
    platform = 'linux-x86' if sys.platform != 'darwin' else 'darwin-x86'
    path = os.path.join('prebuilts/clang/host', platform,
                        'clang-stable/lib64/clang')
    clang_inc_path = FindNearest(cwd, path)

    # TODO: change based on platform
    # path = 'prebuilts/sdk/tools/linux/lib64/libclang.so'
    path = 'out/host/linux-x86/lib64/libclang.so'
    clang_lib_path = os.path.dirname(FindNearest(cwd, path))

    clang = {
        'lib': os.path.join(clang_lib_path, 'libclang.so'),
        'others': [
            os.path.join(clang_lib_path, 'libLLVM.so'),
            os.path.join(clang_lib_path, 'libc++.so'),
        ]
    }
    # 'lib': os.path.join(ycmd_path, 'libclang.so')
    # clang_lib = None

    for dirpath, dirnames, filenames in os.walk(clang_inc_path):
      # if clang_lib and dirpath == clang_lib:
      #   for f in filenames:
      #     if 'aarch64' in f and f.endswith(".so"):
      #       clang['lib'] = os.path.join(dirpath, f)
      #       logging.info("Found clang lib at: " + clang['lib'])
      #       break
      # else:
        if 'include' in dirnames:
          clang['include'] = os.path.join(dirpath, 'include')
          logging.info("Found includes lib at: " + clang['include'])
          break
        # if 'lib' in dirnames:
        #   clang_lib = os.path.join(dirpath, 'lib/linux')

    if 'include' in clang and 'lib' in clang:
      return clang

    return None
  except RuntimeError:
    return None


def YcmCorePreload():
  path_to_ycm_core = FindInPath('ycm_core.so')
  try:
    path_to_ycm_client_support = FindInPath('ycm_client_support.so')
  except:
    path_to_ycm_client_support = None
  path_to_ycmd = os.path.dirname(path_to_ycm_core)

  clang = GetGoogle3Clang() or \
          GetGoogleYcmClang(path_to_ycmd)
  # clang = GetAndroidClang(path_to_ycmd)

  # if no clang found then revert to regular ycm clang
  if not clang:
    return

  global _ycm_temp_dir
  if _ycm_temp_dir is None:
    _ycm_temp_dir = tempfile.mkdtemp('.' + str(os.getpid()), 'ycm_temp-')

  shutil.copy(path_to_ycm_core, _ycm_temp_dir)
  if path_to_ycm_client_support:
    shutil.copy(path_to_ycm_client_support, _ycm_temp_dir)
  shutil.copy(clang['lib'], os.path.join(_ycm_temp_dir, 'libclang.so'))
  shutil.copytree(clang['include'],
                  os.path.join(_ycm_temp_dir, 'clang_includes/include'))

  # if there are any extra libs copy
  for o in clang.get('others', []):
    shutil.copy(o, _ycm_temp_dir)
  MakeEverythingUnderFolderOwnerAccessible(_ycm_temp_dir)

  sys.path.insert( 0, _ycm_temp_dir )
  logging.info("Set path for ycm_temp dir: " + _ycm_temp_dir)


def VimClose():
  if _ycm_temp_dir is not None:
    shutil.rmtree( _ycm_temp_dir )
