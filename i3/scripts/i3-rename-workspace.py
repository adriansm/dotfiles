#!/usr/bin/env python3

## This script is used to dynamically rename workspace names in i3.
# When run, it presents a text field popup using zenity, in which you can type a
# new name for the workspace. It is compatible with the i3-autoname-workspaces
# script and renames only the "shortname" of the workspace, keeping the number
# and window icons in place.
#
# Note that this script can be used without i3-autoname-workspaces.py
#
# Dependencies:
# * zenity - install with system package manager
# * i3ipc - install with pip

import i3ipc
import logging
import subprocess as proc
import sys

from util import *

logging.basicConfig(level=logging.INFO)

i3 = i3ipc.Connection()

def get_current_workspace():
  return [w for w in i3.get_workspaces() if w.focused][0]

def prompt_workspace_name(name=None):
  try:
    # use zenity to show a text box asking the user for a new workspace name
    prompt_title = "Rename Workspace%s:" % (" '{}'".format(name) if name else '' )
    response = proc.check_output(['zenity', '--entry', "--text=%s" % prompt_title])
    new_shortname = response.decode('utf-8').strip()
    logging.info("New name from user: '%s'" % new_shortname)

    if ' ' in new_shortname:
      msg = "No spaces allowed in workspace names"
      logging.error(msg)
      proc.check_call(['zenity', '--error', '--text=%s' % msg])
      return None

    return new_shortname
  except proc.CalledProcessError as e:
    logging.info("Cancelled by user, exiting...")
    return None

workspace = get_current_workspace()
logging.info("Renaming workspace: %s" % workspace.name)
name_parts = parse_workspace_name(workspace.name)
shortname = name_parts.get('shortname')
logging.info("Current workspace shortname: '%s'" % shortname)
logging.info("Parts: " + str(name_parts))

new_shortname = prompt_workspace_name(shortname) if len(sys.argv) < 2 else sys.argv[1]
if new_shortname:
  name_parts['shortname'] = new_shortname
  new_name = construct_workspace_name(name_parts)

  # get the current workspace and rename it
  res = i3.command('rename workspace to "%s"' % new_name)
