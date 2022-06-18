from dotbot import Plugin
from dotbot.plugins.link import Link
from sys import platform as _platform

class OsLink(Plugin):
    _directive = 'oslink'

    def __init__(self, context):
        super(OsLink, self).__init__(context)
        self.link = Link(context)

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Link cannot handle directive %s' % directive)

        return self._process_os_links(data)

    def _get_ostype(self):
        self._log.debug('Platform: ' + _platform)
        for os in ['linux', 'darwin', 'win']:
            if _platform.startswith(os):
                return os
        return None

    def _process_os_links(self, data):
        links = {}
        defaults = self._context.defaults().get(self._directive, {})
        current_os = self._get_ostype()

        for destination, source in data.items():
            target_os = defaults.get('os', None)
            if isinstance(source, dict):
                target_os = source.get('os', target_os)

            if target_os is not None:
                if isinstance(target_os, list):
                    valid_os = current_os in target_os
                else:
                    valid_os = target_os == current_os

                if not valid_os:
                    continue

            links[destination] = source
        return self.link._process_links(links)


