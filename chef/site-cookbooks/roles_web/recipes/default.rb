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

#node['web']['database_server'] = '10.76.34.34'
#node['web']['nfs_server']      = '10.76.34.34'
#node['web']['msg_q']      = 'https://ord.queues.api.rackspacecloud.com/v1/queues/devq'

include_recipe "apache2_config"
include_recipe "php"

