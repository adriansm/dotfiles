from dotbot import Plugin
import subprocess


class Apt(Plugin):
    _directive = 'apt'

    def __init__(self, context):
        super(Apt, self).__init__(context)

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Apt cannot handle directive %s' % directive)

        return self._process(data)

    def _install(self, packages):
        self._log.lowinfo('Installing missing packages with apt: ' + ", ".join(packages))

        cmd = 'sudo apt-get update && sudo apt-get install -y ' + ' '.join(packages)
        try:
            subprocess.check_call(cmd, shell=True)
            self._log.info('Apt packages are successfully installed')
            return True
        except subprocess.CalledProcessError:
            self._log.error('Apt install command failed')
            return False

    def _get_missing_packages(self, packages):
        cmd = ['dpkg-query', '--show', '--showformat=${binary:Package}\\n', '--'] + packages

        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        if p.returncode == 0:
            self._log.debug('No packages left to install')
            # all packages are already installed
            return None

        output, err = p.communicate()
        existing = output.decode('utf-8').splitlines()

        self._log.lowinfo('Some apt packages already installed: ' +
                          ', '.join(existing))

        return [p for p in packages if p not in existing]

    def _process(self, packages):
        missing_packages = self._get_missing_packages(packages)
        if missing_packages:
            return self._install(missing_packages)
        else:
            self._log.info('All apt packages are already installed')
            return True
