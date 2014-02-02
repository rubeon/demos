name             'roles_app'
maintainer       ''
maintainer_email 'DevOpsAdvisory-INTL@RACKSPACE.COM'
license          'Apache 2.0'
description      'Installs/Configures roles_app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

#### APP recipes
depends "java"
depends "java_config"
depends "jboss"
