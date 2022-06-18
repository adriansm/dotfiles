#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies
# * xorg-xprop - install through system package manager
# * i3ipc - install with pip
# * fontawesome - install with pip
#
# Installation:
# * Download this script and place it in ~/.config/i3/ (or anywhere you want)
# * Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to your i3 config
# * Restart i3: "$ i3-msg restart"
#
# Configuration:
# The default i3 config's keybingings reference workspaces by name, which is an
# issue when using this script because the "names" are constantaly changing to
# show window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1

import re
import subprocess as proc
import signal
import sys

import fontawesome as fa
import i3ipc

from i3_workspace import Workspace


# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# Most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_INFO = {
    'termite': fa.icons.get('terminal'),
    'urxvt': fa.icons.get('terminal'),
    'gnome-terminal': fa.icons.get('terminal'),
    'x-terminal-emulator': fa.icons.get('terminal'),
    'chromium': (fa.icons.get('chrome'), 'Web'),
    'google-chrome': (fa.icons.get('chrome'), 'Web'),
    'spotify': fa.icons.get('music'), # could also use 'spotify' from font awesome
    'firefox': fa.icons.get('firefox'),
    'libreoffice': fa.icons.get('file-text-o'),
    'feh': fa.icons.get('picture-o'),
    'mupdf': fa.icons.get('file-pdf-o'),
    'evince': fa.icons.get('file-pdf-o'),
    'thunar': fa.icons.get('files-o'),
    'gpick': fa.icons.get('eyedropper'),
    'atom': fa.icons.get('code'),
    'steam': fa.icons.get('steam'),
    'zenity': fa.icons.get('window-maximize'),
    'chrome-personal': (fa.icons.get('chrome'), 'Personal'),
}

# This icon is used for any application not in the list above
DEFAULT_ICON = ''


# Returns an array of the values for the given property from xprop.  This
# requires xorg-xprop to be installed.
def xprop(win_id, prop):
  try:
    prop = proc.check_output(
      ['xprop', '-id', str(win_id), prop], stderr=proc.DEVNULL)
    prop = prop.decode('utf-8')
    return re.findall('"([^"]+)"', prop)
  except proc.CalledProcessError:
    print("Unable to get property for window '%d'" % win_id)
    return None

def info_for_window(window):
  classes = xprop(window.window, 'WM_CLASS')
  if classes:
    for cls in classes:
      # case-insensitive matching
      info = WINDOW_INFO.get(cls.lower(), None)
      if info:
        if isinstance(info, tuple):
          return info

        return info, None
    print('No icon available for window with classes: %s' % str(classes))
  return DEFAULT_ICON, None

# renames all workspaces based on the windows present
def rename_workspaces(i3):
  for workspace in i3.get_tree().workspaces():
    ws: Workspace = Workspace(workspace, i3=i3)
    icons = set()
    names = set()
    for w in workspace.leaves():
      icon, name = info_for_window(w)
      if icon:
        icons.add(icon)
      if name:
        names.add(name)

    name = names.pop() if len(names) == 1 else None
    ws.set_suggestedname(name=name, icons=icons)


# rename workspaces to just numbers and shortnames.
# called on exit to indicate that this script is no longer running.
def undo_window_renaming(i3):
  for workspace in i3.get_tree().workspaces():
    ws: Workspace = Workspace(workspace, i3=i3)
    ws.set_icons(None)
    i3.main_quit()
    sys.exit(0)


if __name__ == '__main__':
  i3 = i3ipc.Connection()

  # exit gracefully when ctrl+c is pressed
  for sig in [signal.SIGINT, signal.SIGTERM]:
    signal.signal(sig, lambda signal, frame: undo_window_renaming(i3))

    # call rename_workspaces() for relevant window events
    def window_event_handler(i3, e):
      if e.change in ['new', 'close', 'move']:
        rename_workspaces(i3)
    i3.on('window', window_event_handler)

    rename_workspaces(i3)

    i3.main()
