#
# Cookbook Name:: roles_db
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

passwords = Chef::EncryptedDataBagItem.load("config", "passwords")
node.set['rackspace_mysql']['port'] = '3306'
node.set['rackspace_mysql']['data_dir'] = '/var/lib/mysql'
node.set['rackspace_mysql']['server_root_password'] = passwords["mysql_root"]
node.set['rackspace_mysql']['remove_anonymous_users'] = 'yes'
node.set['rackspace_mysql']['remove_test_database'] = 'yes'

include_recipe "rackspace_mysql::server"

add_iptables_rule('INPUT', '-s 0.0.0.0 -p tcp --dport 3306 -j ACCEPT')

include_recipe "website_one_db"

