#
# Cookbook Name:: jboss_app
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

#### Deploy apps

node['jboss_app']['wars'].each do |warfile, index|
    remote_file node['jboss']['home'] + "/" + node['jboss']['instance'] + "/" + node['jboss_app']['webapps_dir'] + "/" + warfile do
        action :create_if_missing
        source  node['jboss_app']['war_url_base'] + warfile
        owner node['jboss']['user']
        group node['jboss']['group']
    end
end


#### Start jboss service
service "jboss" do
  service_name "jboss"
  action [ :enable, :start ]
end
