name             'roles_app'
maintainer       ''
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures roles_app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

#### APP recipes
depends "java"
depends "java_config"
depends "jboss"
depends "jboss_app"

