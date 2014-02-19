name             'roles_db'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_db'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.4'

depends "openssl"
depends "rackspace_mysql"
depends "rackspace_build_essential"
depends "website_one_db"
