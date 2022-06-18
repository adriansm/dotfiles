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

class Workspace(object):
  def __init__(self, i3_workspace):
    self.i3_workspace = i3_workspace
    self.name_parts = parse_workspace_name(i3_workspace.name)

  @staticmethod
  def get_current_workspace():
    for w in i3.get_workspaces():
      if w.focused:
        return Workspace(w)
    return None

  def _rename(self):
    new_name = construct_workspace_name(self.name_parts)
    return i3.command('rename workspace to "%s"' % new_name)

  def change_icon(self, icon):
    self.name_parts['icon'] = icon
    return self._rename()

  def change_shortname(self, shortname):
    self.name_parts['shortname'] = shortname
    return self._rename()

  def get_shortname(self):
    return self.name_parts.get('shortname')

def prompt_workspace_name(name=None):
  prompt_title = "Rename Workspace%s:" % (" '{}'".format(name) if name else '' )
  try:
    # use zenity to show a text box asking the user for a new workspace name
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

if __name__ == '__main__':
  workspace = Workspace.get_current_workspace()
  logging.info("Renaming workspace: %s" % workspace.get_shortname())

  new_shortname = prompt_workspace_name(workspace.get_shortname()) if len(sys.argv) < 2 else sys.argv[1]
  logging.info("New workspace name: %s" % new_shortname)
  if new_shortname:
    workspace.change_shortname(new_shortname)
