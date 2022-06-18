import sys
import subprocess
from dotbot import Plugin

class Dispatcher(object):
    def __init__(self, context):
        self._context = context
        self._plugins = [plugin(self._context)
                         for plugin in Plugin.__subclasses__()]

    def _dispatch_task(self, task):
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

    def dispatch(self, tasks):
        success = True
        if isinstance(tasks, list):
            for task in tasks:
                success &= self._dispatch_task(task)
        elif isinstance(tasks, dict):
            success &= self._dispatch_task(tasks)
        else:
            raise ValueError('Invalid actions')
        return success


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
            'shell': self._is_shell,
        }
        self._dispatcher = None

    def can_handle(self, directive):
        return directive == self._directive

    def _is_bool(self, data):
        return data

    def _is_os(self, data):
        return self._os in data if isinstance(data, list) else data == self._os

    def _is_shell(self, data):
        return 0 == subprocess.call(data, shell=True, cwd=self._context.base_directory())

    def _process_conditional(self, key, data):
        if key in ['or', 'and']:
            comp = any if key == 'or' else all
            if isinstance(data, list):
                return comp(self._process_conditional(key, i) for i in data)
            elif isinstance(data, dict):
                return comp(self._process_conditional(k, v) for k, v in data.items())
            elif isinstance(data, bool):
                return data
            else:
                raise ValueError('Invalid conditional found %s' % str(data))
        elif key in self._sub_directives:
            func = self._sub_directives[key]
            return func(data)
        else:
            raise ValueError('Invalid conditional %s' % key)

    def _process_actions(self, actions):
        # lazy load dispatcher
        if self._dispatcher is None:
            self._dispatcher = Dispatcher(self._context)

        return self._dispatcher.dispatch(actions)

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
                raise ValueError('Only a single conditional can be processed. Consider consider using and/or directives')

        if actions is None:
            self._log.error('No actions found')
            return False
        elif conditional is None:
            self._log.error('No conditional found')
            return False

        if conditional:
            return self._process_actions(actions)

        self._log.debug('Skipping actions because of conditional')
        return True


