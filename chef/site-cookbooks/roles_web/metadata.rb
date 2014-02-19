name             'roles_web'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_web'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

depends "apache2"
depends "rackspace_php"
depends "rackspace_mysql"
depends "website_one"

