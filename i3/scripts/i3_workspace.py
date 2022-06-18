#!/usr/bin/env python3

import logging
import re
import subprocess

import click
from i3ipc import Connection as I3Connection

logging.basicConfig(level=logging.INFO)

def prompt_workspace_name(name=None):
  prompt_title = "Rename Workspace%s:" % (" '{}'".format(name) if name else '')
  try:
    # use zenity to show a text box asking the user for a new workspace name
    response = subprocess.check_output(['zenity', '--entry', "--text=%s" % prompt_title])
    new_shortname = response.decode('utf-8').strip()
    logging.info("New name from user: '%s'", new_shortname)

    if ' ' in new_shortname:
      msg = "No spaces allowed in workspace names"
      logging.error(msg)
      subprocess.check_call(['zenity', '--error', '--text=%s' % msg])
      return None

    return new_shortname
  except subprocess.CalledProcessError:
    logging.info("Cancelled by user, exiting...")

  return None


class Workspace():
  def __init__(self, i3_workspace, **kwargs):
    self.i3: I3Connection = kwargs.get('i3', I3Connection())
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
    data = re.match(r'(?P<num>\d+):?(?P<icons>([ ][^A-Za-z])*) ?(?P<shortname>\w+[ ]?$)?', name).groupdict()

    self.name_parts['num'] = int(data['num'])
    if data['icons']:
      self.name_parts['icons'] = data['icons'].strip().split()
    self.name_parts['shortname'] = data.get('shortname')

  def get_name(self):
    new_name = str(self.get_num())
    shortname = self.get_shortname()
    icons = self.get_icons()
    if shortname or icons:
      new_name += ':'

      if icons:
        new_name += ' ' + ' '.join(icons)

      if shortname:
        new_name += ' ' +  shortname

    return new_name

  def refresh(self):
    for w in self.i3.get_workspaces():
      if w.num == self.get_num():
        self.parse_name(w.name)
        return w.name
    raise Exception('Could not find workspace %d' % (self.get_num()))

  def update(self, new_values):
    ws_name = self.refresh()

    for k, v in new_values.items():
      self.name_parts[k] = v
    new_name = self.get_name()
    logging.info('Renaming workspace "%s" to "%s"', ws_name, new_name)

    output = self.i3.command('rename workspace "%s" to "%s"' % (ws_name, new_name))
    logging.info('Output: %s', output)
    return output

  def get_icons(self):
    return self.name_parts.get('icons')

  def get_num(self):
    return self.name_parts.get('num')

  def get_shortname(self):
    return self.name_parts.get('shortname')

  def set_icons(self, icons, **kwargs):
    update = {
        'icons': icons
    }
    self.update(update)

  def set_shortname(self, shortname, **kwargs):
    update = {
        'shortname': shortname
    }
    self.update(update)

  def set_suggestedname(self, **kwargs):
    name = kwargs.get('name')
    icons = kwargs.get('icons')
    current_name = self.get_shortname()
    update = {}
    if name and (current_name is None or current_name[-1:] == ' '):
      update['shortname'] = name + ' '
    if icons is not None:
      update['icons'] = icons

    if update:
      self.update(update)


# TODO: allow specifying workspace
@click.group()
@click.pass_context
def cli(ctx=None):
  ctx.obj = Workspace.get_current_workspace()


@cli.command(short_help='Rename workspace')
@click.argument('name', nargs=1, required=False, default=None)
@click.pass_context
def rename(ctx, name):
  ws: Workspace = ctx.obj

  logging.info("Renaming workspace: %s", ws.get_shortname())

  if name is None:
    name = prompt_workspace_name(ws.get_shortname())
    # HACK: workspace may change with prompt, so getting it again
    ws = Workspace.get_current_workspace()
  logging.info("New workspace name: %s", name)
  if name is not None:
    ws.set_shortname(name)


if __name__ == '__main__':
  cli()
