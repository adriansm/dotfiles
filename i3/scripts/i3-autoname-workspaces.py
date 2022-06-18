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


import i3ipc
import subprocess as proc
import signal
import sys
import fontawesome as fa

from util import *


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
WINDOW_ICONS = {
    'termite': fa.icons.get('terminal'),
    'urxvt': fa.icons.get('terminal'),
    'gnome-terminal': fa.icons.get('terminal'),
    'chromium': fa.icons.get('chrome'),
    'google-chrome': fa.icons.get('chrome'),
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
    'chrome-personal': fa.icons.get('chrome'),
}

# This icon is used for any application not in the list above
DEFAULT_ICON = ''


# Returns an array of the values for the given property from xprop.  This
# requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = proc.check_output(['xprop', '-id', str(win_id), property], stderr=proc.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall('"([^"]+)"', prop)
    except proc.CalledProcessError as e:
        print("Unable to get property for window '%d'" % win_id)
        return None

def icon_for_window(window):
    classes = xprop(window.window, 'WM_CLASS')
    if classes:
        for cls in classes:
            # case-insensitive matching
            icon = WINDOW_ICONS.get(cls.lower(), None)
            if icon:
                return icon
        print('No icon available for window with classes: %s' % str(classes))
    return DEFAULT_ICON

# renames all workspaces based on the windows present
# also renumbers them in ascending order, with one gap left between monitors
# for example: workspace numbering on two monitors: [1, 2, 3], [5, 6]
def rename_workspaces(i3):
    ws_infos = i3.get_workspaces()
    prev_output = ""
    n = 1
    for ws_index, workspace in enumerate(i3.get_tree().workspaces()):
        ws_info = ws_infos[ws_index]

        name_parts = parse_workspace_name(workspace.name)
        icons = {icon_for_window(w) for w in workspace.leaves()}
        name_parts['icons'] = ' '.join(icons)

        new_name = construct_workspace_name(name_parts)
        print('Rename %s to %s' % (workspace.name, new_name))
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))

# rename workspaces to just numbers and shortnames.
# called on exit to indicate that this script is no longer running.
def undo_window_renaming(i3):
    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = None
        new_name = construct_workspace_name(name_parts)
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))
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