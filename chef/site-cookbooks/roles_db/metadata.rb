name             'roles_db'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_db'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.4'


#### DB recipes
depends "mysql"
depends "mysql_config"
depends "partial_search"
