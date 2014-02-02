name             'roles_web'
maintainer       ''
maintainer_email 'DevOpsAdvisory-INTL@RACKSPACE.COM'
license          'Apache 2.0'
description      'Installs/Configures roles_web'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

#### WEB recipes
depends "apache2"
depends "apache2_config"
depends "php"
