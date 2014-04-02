name             'roles_jenkins_servers'
maintainer       ''
maintainer_email 'DevOpsAdvisory-INTL@RACKSPACE.COM'
license          'Apache 2.0'
description      'Installs/Configures roles_jenkins_servers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends "java"
depends "apt"
depends "runit"
depends "jenkins"
