#
# Cookbook Name:: mysql_config
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

node.override['mysql']['port'] = '3306'
node.override['mysql']['data_dir'] = '/var/lib/mysql'
node.override['mysql']['server_root_password'] = 'helloworld'
node.override['mysql']['remove_anonymous_users'] = 'yes'
node.override['mysql']['remove_test_database'] = 'yes'

include_recipe "mysql::server"



