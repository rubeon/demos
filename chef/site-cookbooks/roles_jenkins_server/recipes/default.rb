#
# Cookbook Name:: roles_jenkins_servers
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

node.default['java']['jdk_version'] = '7'
node.default['java']['oracle_rpm']['type'] = 'jdk'
node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk']['7']['x86_64']['url'] = 'http://c3fdc85d8f10b46c057a-4a7c6ed24e9f3add9b0486ca48ec12a1.r1.cf3.rackcdn.com/jdk-7u45-linux-x64.tar.gz'
node.default['java']['jdk']['7']['x86_64']['checksum'] = "f2eae4d81c69dfa79d02466d1cb34db2b628815731ffc36e9b98f96f46f94b1a"
node.default['java']['java_home'] = "/usr/local/java/default"
include_recipe "java"

node.default['jenkins']['master']['install_method'] = "package"
include_recipe "jenkins::master"

# Create password credentials
jenkins_password_credentials 'wcoyote' do
  description 'Wile E Coyote'
  password    'beepbeep123456'
end

add_iptables_rule('INPUT', '-s 0.0.0.0 -p tcp --dport 8080 -j ACCEPT')

