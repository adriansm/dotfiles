#!/usr/bin/env python3

import click
import logging
import re
import subprocess
from i3ipc import Connection as I3Connection


def prompt_workspace_name(name=None):
  prompt_title = "Rename Workspace%s:" % (" '{}'".format(name) if name else '' )
  try:
    # use zenity to show a text box asking the user for a new workspace name
    response = subprocess.check_output(['zenity', '--entry', "--text=%s" % prompt_title])
    new_shortname = response.decode('utf-8').strip()
    logging.info("New name from user: '%s'" % new_shortname)

    if ' ' in new_shortname:
      msg = "No spaces allowed in workspace names"
      logging.error(msg)
      subprocess.check_call(['zenity', '--error', '--text=%s' % msg])
      return None

    return new_shortname
  except subprocess.CalledProcessError as e:
    logging.info("Cancelled by user, exiting...")

  return None


class Workspace(object):
  def __init__(self, i3_workspace, **kwargs):
    self.i3: I3Connection = kwargs.get('i3', I3Connection())
    self.i3_workspace = i3_workspace
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
    data = re.match('(?P<num>\d+):?(?P<icons> [^\w])* ?(?P<shortname>\w+)?', name).groupdict()

    if data['icons']:
      data['icons'] = data['icons'].strip()
    self.name_parts = data

  def get_name(self):
    new_name = str(self.get_num())
    shortname = self.get_shortname()
    icon = self.get_icons()
    if shortname or icon:
      new_name += ':'

      if icon:
        new_name += ' ' + icon

      if shortname:
        new_name += ' ' +  shortname

    return new_name

  def _rename(self):
    new_name = self.get_name()
    logging.info('Renaming workspace "%s" to "%s"' % (self.i3_workspace.name, new_name))

    return self.i3.command('rename workspace to "%s"' % new_name)

  def get_icons(self):
    return self.name_parts.get('icons')

  def set_icons(self, icon):
    if isinstance(icon, str):
      icon = icon.strip()
    # TODO: more validation?
    self.name_parts['icons'] = icon
    return self._rename()

  def get_num(self):
    return self.name_parts.get('num')

  def get_shortname(self):
    return self.name_parts.get('shortname')

  def set_shortname(self, shortname):
    self.name_parts['shortname'] = shortname
    return self._rename()


# TODO: allow specifying workspace
@click.group()
@click.pass_context
def cli(ctx):
  ctx.obj = Workspace.get_current_workspace()


@cli.command(short_help='Rename workspace')
@click.argument('name', nargs=1, required=False, default=None)
@click.pass_context
def rename(ctx, name):
  ws: Workspace = ctx.obj

  logging.info("Renaming workspace: %s" % ws.get_shortname())

  if not name:
    name = prompt_workspace_name(ws.get_shortname())
  logging.info("New workspace name: %s" % name)
  if name:
    ws.set_shortname(name)


if __name__ == '__main__':
  cli()