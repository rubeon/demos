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

include_recipe "apache2::default"

include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# Override defaults for the recipe
node.override['apache']['listen_addresses'] = ["*"]
node.override['apache']['listen_ports']  = ["80","443"]
node.override['apache']['timeout'] = 100
node.override['apache']['keepalive'] = true
node.override['apache']['keepaliverequests'] = 100
node.override['apache']['keepalivetimeout'] = 3

web_app "one.example.com" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "one.example.com"]
  docroot "/srv/www/one.example.com"
end


iptables_rule "port_httpd"
