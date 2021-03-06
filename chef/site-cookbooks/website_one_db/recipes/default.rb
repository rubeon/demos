#
# Cookbook Name:: website_one_db
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

node.set['website_one_db']['db_remote_url'] = "http://ca05e8171724524c805e-f85013b2b105db9295d244236b43548b.r11.cf3.rackcdn.com/world_innodb.sql"
node.set['website_one_db']['db_remote_filename'] = "world_innodb.sql"
node.set['website_one_db']['db_download_location'] = "/tmp"


local_db_file = node['website_one_db']['db_download_location'] + "/" + node['website_one_db']['db_remote_filename']
remote_file local_db_file do
  action :create_if_missing
  source node['website_one_db']['db_remote_url']
end

passwords = Chef::EncryptedDataBagItem.load("config", "passwords")
mysql_host = 'localhost'
mysql_username = 'root'
mysql_password =   passwords["mysql_root"]
mysql_app_password =   passwords["mysql_app"]
mysql_app_db_name = "world"


execute "mysql_create_db" do
    command "mysql -u#{mysql_username} -p#{mysql_password}  -e 'create database if not exists #{mysql_app_db_name}'"
end

execute "mysql_load_db" do
    command "mysql -u#{mysql_username} -p#{mysql_password} #{mysql_app_db_name} < #{local_db_file}"
end


execute "mysql_create_app_user_grants" do
    command "mysql -u#{mysql_username} -p#{mysql_password} -e \"GRANT ALL on #{mysql_app_db_name}.* to 'app'@'%' \""
end

execute "mysql_create_app_user_pwd" do
    command "mysql -u#{mysql_username} -p#{mysql_password} -e \"set password for 'app'@'%' = PASSWORD('#{mysql_app_password}') \""
end




