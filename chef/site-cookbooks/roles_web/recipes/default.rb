#
# Cookbook Name:: roles_web
# Recipe:: default
#
# Copyright 2014, 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


#
# Cookbook Name:: apache2_config
# Recipe:: default
#
# Copyright 2013, 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

### Apache settings
# Override defaults for the recipe
node.set['apache']['listen_addresses'] = ["*"]
node.set['apache']['listen_ports']  = ["80","443"]
node.set['apache']['timeout'] = 100
node.set['apache']['keepalive'] = true
node.set['apache']['keepaliverequests'] = 100
node.set['apache']['keepalivetimeout'] = 3

include_recipe "apache2::default"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# Add iptables rules for Apache
add_iptables_rule('INPUT', '-s 0.0.0.0 -p tcp --dport 80 -j ACCEPT')
add_iptables_rule('INPUT', '-s 0.0.0.0 -p tcp --dport 443 -j ACCEPT')

### Mysql client
include_recipe "rackspace_mysql::client"


### PHP
node.set['rackspace_php']['packages'] = ["php-mysql", "php" , "php-cli", "php-pear"]
include_recipe "rackspace_php"

### Cookbook to deploy sample website
include_recipe "website_one"

