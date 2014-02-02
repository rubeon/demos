name             'roles_base'
maintainer       ''
maintainer_email 'DevOpsAdvisory-INTL@RACKSPACE.COM'
license          'Apache 2.0'
description      'Installs/Configures roles_base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "build-essential"
depends "iptables"
depends "base_pkgs"
depends "users"
depends "motd"
depends "sshd"
depends "sudo"
depends "sudo_config"
depends "logrotate"
depends "logrotate_config"
depends "cron"
depends "cron_config"
depends "sysctl"
depends "sysctl_config"
depends "remove_validation"

