#
# Cookbook Name:: website_one
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


### Get IP of the DB server
dbnodes = search(:node, "role:db")
node.set["website_one"]["db_host"] = dbnodes.first[:rackspace][:private_ip]


#### Create Apache vhost

web_app "one.example.com" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "one.example.com"]
  docroot "/srv/www/one.example.com"
end


### Upload site content

# Create directory
directory node["website_one"]["site_root"] do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00755
  action :create
  recursive true
end

local_tar_file = node["website_one"]["site_root"] + "/" + node["website_one"]["site_remote_filename"]

remote_file local_tar_file do
  action :create_if_missing
  source node["website_one"]["site_remote_url"]
end

bash 'extract_module' do
  code <<-EOH
    tar xzf #{local_tar_file} -C #{node["website_one"]["site_root"]}
    chown -R #{node['apache']['user']}:#{node['apache']['group']} #{node["website_one"]["site_root"]}
    EOH
end

### Create a database configuration file

template node["website_one"]["site_db_conf"]  do
    source "dbconf.erb"
    mode 0440
    owner node['apache']['user']
    group node['apache']['group']
    passwords = Chef::EncryptedDataBagItem.load("config", "passwords")
    variables(
      :db_host => node['website_one']['db_host'],
      :db_user => node['website_one']['db_user'],
      :db_password =>  passwords[node["website_one"]["db_pass_data_bag_item"]],
      :db_name => node['website_one']['db_name']
    )
end
