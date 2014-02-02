name             'roles_base'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "remove_validation"

depends "build-essential"
depends "iptables"
depends "base_pkgs"
depends "sudo"
depends "sudo_config"
depends "users"
depends "motd"
depends "sshd"
depends "cron"
depends "cron_config"
depends "logrotate"
depends "logrotate_config"
depends "sysctl"
depends "sysctl_config"

