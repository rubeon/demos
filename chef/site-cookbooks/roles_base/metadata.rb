name             'roles_base'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.5'

depends "remove_validation"
depends "rackspace_build_essential"
depends "rackspace_user"
depends "rackspace_iptables"

depends "rackspace_sudo"
depends "rackspace_motd"
depends "rackspace_ntp"
depends "rackspace_openssh"
depends "rackspace_apt"
depends "rackspace_yum"
depends "rackspace_logrotate"
depends "rackspace_sysctl"
depends "base_pkgs"
depends "cron"

