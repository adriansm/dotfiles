import unittest
import tempfile

from ycm_extra_conf import ProcessFlags

class TestYcmConfRelativeFlags(unittest.TestCase):
  def call_and_compare(self, expected, input, workingdir = None):
    self.assertEquals(expected, ProcessFlags(input, workingdir))

  def test_no_workingdir(self):
    self.call_and_compare([], [])

    data = ['-I some/path/relative', '-I/some/absolute/path']
    self.call_and_compare(data, data)

  def test_absolute_paths(self):
    input = ['-I/other/path', '-I /some/absolute/path', '-isystem /another/one']
    expected = ['-I/other/path', '-I/some/absolute/path', '-isystem/another/one']
    self.call_and_compare(expected, input, '/project/path')

  def test_no_action_flags(self):
    flags = ['-Werror', '-fshort-wchar', '-g', '-DNDEBUG', '-std=gnu89']
    self.call_and_compare(flags, flags, '/project/path')

  def test_include_file(self):
    includes = ['-I/first/abs/path', '-I/second/abs/path']
    with tempfile.NamedTemporaryFile() as fp:
      fp.write("\n".join(includes))
      fp.file.flush()

      flags = ['@%s' % fp.name]
      self.call_and_compare(includes, flags, "/some/path")


if __name__ == '__main__':
    unittest.main()