#
# Cookbook Name:: jboss
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

#### create users and groups

group node['jboss']['group']  do
    action :create
end

user node['jboss']['user'] do
    comment "Jboss User"
    gid node['jboss']['group']
    home node['jboss']['user_home']
    supports :manage_home => true
    action :create
end

#### Create dir and download tar ball

directory node['jboss']['home'] do
    owner "root"
    group "root"
    mode 00755
    action :create
end

remote_file node['jboss']['home'] + "/" + node['jboss']['tar_folder'] + ".tar.gz" do
    action :create_if_missing
    source  node['jboss']['url']
end

extract_path = node['jboss']['home']
src_filename  = node['jboss']['home'] + "/" + node['jboss']['tar_folder'] + ".tar.gz"
jboss_user = node['jboss']['user']
jboss_group  = node['jboss']['group']
jboss_home  = node['jboss']['home']

bash 'extract_module' do
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path}
    chown -R #{jboss_group}:#{jboss_group} #{jboss_home}
    EOH
  not_if { ::File.exists?(extract_path+node['jboss']['tar_folder']) }
end


link node['jboss']['home'] + "/" + node['jboss']['instance'] do
  to node['jboss']['home'] + "/" + node['jboss']['tar_folder']
end


#### Create init script

template "/etc/init.d/jboss" do
  source "jboss_init.erb"
  mode "0755"
  owner "root"
  group "root"
end

#### Create the standalone configuration and script.

template node['jboss']['home'] + "/" + node['jboss']['instance'] + "/standalone/configuration/standalone.conf" do
  source 'standalone_conf.erb'
  owner node['jboss']['user']
end

template node['jboss']['home'] + "/" + node['jboss']['instance'] + "/bin/standalone.sh" do
  source 'standalone_sh.erb'
  owner node['jboss']['user']
  mode 00755
end


