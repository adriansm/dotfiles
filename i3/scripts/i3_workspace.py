#!/usr/bin/env python3

import fcntl
import logging
import re
import subprocess

import click
from i3ipc import Connection as I3Connection

logging.basicConfig(level=logging.INFO)


def prompt_workspace_name(name=None):
  prompt_title = 'Rename Workspace%s:' % (' ' + name if name else '')
  try:
    # use zenity to show a text box asking the user for a new workspace name
    response = subprocess.check_output(['zenity', '--entry', '--text=%s' % prompt_title])
    new_shortname = response.decode('utf-8').strip()
    logging.info('New name from user: \'%s\'', new_shortname)

    if ' ' in new_shortname:
      msg = 'No spaces allowed in workspace names'
      logging.error(msg)
      subprocess.check_call(['zenity', '--error', '--text=%s' % msg])
      return None

    return new_shortname
  except subprocess.CalledProcessError:
    logging.info('Cancelled by user, exiting...')

  return None


class Workspace:

  def __init__(self, i3_workspace, **kwargs):
    self.i3: I3Connection = kwargs.get('i3', I3Connection())
    self.num = i3_workspace.num
    self.name_parts = {}
    self.parse_name(i3_workspace.name)

  @staticmethod
  def get_current_workspace(**kwargs):
    i3 = kwargs.get('i3', I3Connection())

    for w in i3.get_workspaces():
      if w.focused:
        return Workspace(w, i3=i3)

    return None

  def parse_name(self, name):
    data = re.match(
        r'(?P<num>\d+):?(?P<icons>([ ][^A-Za-z])*) ?(?P<shortname>\w+[ ]?$)?',
        name).groupdict()

    # self.name_parts['num'] = int(data['num'])
    if int(data['num']) != self.num:
      logging.warning("Workspace num doesn't match actual: %d", self.num)
    if data['icons']:
      self.name_parts['icons'] = data['icons'].strip().split()
    name = data.get('shortname')
    if name and name[-1:] == ' ':
      self.name_parts['suggestedname'] = name.strip()
    else:
      self.name_parts['shortname'] = name

  def get_name(self):
    new_name = str(self.num)
    shortname = self.get_shortname()
    icons = self.get_icons()

    if not shortname:
      suggestedname = self.name_parts.get('suggestedname')
      if suggestedname:
        shortname = suggestedname + ' '

    if shortname or icons:
      new_name += ':'

      if icons:
        new_name += ' ' + ' '.join(icons)

      if shortname:
        new_name += ' ' +  shortname

    return new_name

  def refresh(self):
    for w in self.i3.get_workspaces():
      if w.num == self.num:
        self.parse_name(w.name)
        return w.name
    raise Exception('Could not find workspace %d' % self.num)

  def update(self, new_values):
    with open(__file__) as f:
      fcntl.flock(f, fcntl.LOCK_EX)
      ws_name = self.refresh()

      for k, v in new_values.items():
        self.name_parts[k] = v
      new_name = self.get_name()
      logging.info('Renaming workspace "%s" to "%s"', ws_name, new_name)

      output = self.i3.command('rename workspace "%s" to "%s"' % (ws_name, new_name))

    logging.debug('Output: %s', str(output))
    return output

  def get_icons(self):
    return self.name_parts.get('icons')

  def get_shortname(self):
    return self.name_parts.get('shortname')

  def set_icons(self, icons, **unused_kwargs):
    update = {
        'icons': icons
    }
    self.update(update)

  def set_shortname(self, shortname, **_unused_kwargs):
    update = {
        'shortname': shortname
    }
    self.update(update)

  def set_suggestedname(self, **kwargs):
    update = {
        'suggestedname': kwargs.get('name'),
    }
    icons = kwargs.get('icons', None)
    if icons is not None:
      update['icons'] = icons

    if update:
      self.update(update)


# TODO(adriansm): allow specifying workspace
@click.group()
@click.pass_context
def cli(ctx=None):
  ctx.obj = Workspace.get_current_workspace()


@cli.command(short_help='Rename workspace')
@click.argument('name', nargs=1, required=False, default=None)
@click.pass_context
def rename(ctx, name):
  ws: Workspace = ctx.obj

  logging.info('Renaming workspace: %s', ws.get_shortname())

  if name is None:
    name = prompt_workspace_name(ws.get_shortname())
    # HACK: workspace may change with prompt, so getting it again
    ws = Workspace.get_current_workspace()
  logging.info('New workspace name: %s', name)
  if name is not None:
    ws.set_shortname(name)


@cli.command(short_help='Switch workspace helper')
@click.option('--switch', is_flag=True,
              help='Switch to workspace')
@click.option('--move-container', is_flag=True,
              help='Move container to workspace')
def next_empty(switch, move_container):
  i3 = I3Connection()

  ws_nums = {w.num: w for w in i3.get_tree().workspaces()}

  w = next((x for x in range(1, 25) if x not in ws_nums), None)
  if w:
    if move_container:
      i3.command('move container to workspace number %d' % w)
    if switch:
      i3.command('workspace number %d' % w)


if __name__ == '__main__':
  cli()
