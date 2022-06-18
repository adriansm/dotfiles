import sys
from dotbot import Plugin


class Conditional(Plugin):
    _directive = 'if'

    def __init__(self, context):
        super(Conditional, self).__init__(context)

        for os in ['linux', 'darwin', 'win']:
            if sys.platform.startswith(os):
                self._os = os

        self._sub_directives = {
            'bool': self._is_bool,
            'os': self._is_os,
        }
        self._plugins = None

    def _process_actions(self, task):
        # lazy load plugins
        if self._plugins is None:
            self._plugins = [plugin(self._context)
                             for plugin in Plugin.__subclasses__()]

        success = True
        for action in task:
            handled = False
            for plugin in self._plugins:
                if plugin.can_handle(action):
                    try:
                        success &= plugin.handle(action, task[action])
                        handled = True
                    except Exception as err:
                        self._log.error(
                            'An error was encountered while executing action %s' %
                            action)
                        self._log.debug(err)
            if not handled:
                success = False
                self._log.error('Action %s not handled' % action)
        return success

    def can_handle(self, directive):
        return directive == self._directive

    def _is_bool(self, data):
        return data

    def _is_os(self, data):
        self._log.debug("Checking OS")
        if isinstance(data, list):
            return self._os in data
        else:
            return data == self._os

    def _process_and(self, data):
        self._log.debug("Processing AND")
        for key, value in data.items():
            if not self._process_conditional(key, value):
                return False
        return True

    def _process_or(self, data):
        self._log.debug("Processing OR")
        for key, value in data.items():
            if self._process_conditional(key, value):
                return True
        return False

    def _process_conditional(self, key, data):
        if key == 'or':
            return self._process_or(data)
        elif key == 'and':
            return self._process_and(data)
        elif key in self._sub_directives:
            func = self._sub_directives[key]
            return func(data)
        else:
            raise ValueError("Invalid conditional %s" % key)

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Conditional cannot handle directive %s' % directive)

        conditional = None
        actions = None
        for key, value in data.items():
            if key == 'actions':
                actions = value
            elif conditional is None:
                conditional = self._process_conditional(key, value)
            else:
                raise ValueError("Only a single conditional can be processed. Consider consider using and/or directives")

        if actions is None:
            self._log.error("No actions found")
            return False
        elif conditional is None:
            self._log.error("No conditional found")
            return False

        if conditional:
            return self._process_actions(actions)

        self._log.debug("Skipping actions because of conditional")
        return True


