#!/usr/bin/python3
import subprocess
import sys


def cloudshell(args):
  sshargs = []
  is_cloudshell = False

  i = 1
  while i < len(args):
    arg = args[i]
    if arg == "cloud-shell":
      is_cloudshell = True
    elif arg[0] == '-':
      if arg[1] in "vT":
        sshargs.append(arg)
      elif arg[1] in "oDLR":
        sshargs.append(' '.join([arg, args[i+1]]))
        i += 1
      else:
        # print("Unknown option: " + arg[1])
        return False
    else:
      # print("Unknown arg: " + arg)
      return False

    i += 1

  if not is_cloudshell:
    return False

  # print("ssh args: " + ' '.join(sshargs))
  cmdargs = ['--ssh-flag="' + arg + '"' for arg in sshargs]
  # print("cmd args: " + ' '.join(cmdargs))

  cmd = ['gcloud', 'alpha', 'cloud-shell', 'ssh'] + cmdargs
  # print("Cmd: " + ' '.join(cmd))
  subprocess.call(' '.join(cmd), shell=True)

  return is_cloudshell


def ssh(args):
  cmd = ['ssh'] + args
  return subprocess.call(cmd)


def main(args):
  return cloudshell(args) or ssh(args[1:])


if __name__ == "__main__":
  main(sys.argv)
