#
# Cookbook Name:: java_config
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

# install jre from Oracle
node.override['java']['jdk_version'] = '7'
node.override['java']['oracle_rpm']['type'] = 'jdk'
node.override['java']['install_flavor'] = 'oracle'
node.override['java']['jdk']['7']['x86_64']['url'] = 'http://c3fdc85d8f10b46c057a-4a7c6ed24e9f3add9b0486ca48ec12a1.r1.cf3.rackcdn.com/jdk-7u45-linux-x64.tar.gz'
node.override['java']['jdk']['7']['x86_64']['checksum'] = "f2eae4d81c69dfa79d02466d1cb34db2b628815731ffc36e9b98f96f46f94b1a"
node.override['java']['java_home'] = "/usr/local/java/default"


include_recipe "java"

