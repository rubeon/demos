#
# Cookbook Name:: rackspace_cloudmonitoring_config
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


cloudcreds = Chef::EncryptedDataBagItem.load("rackspace", "cloud_credentials")

node.override['rackspace']['cloud_credentials']['username'] = cloudcreds["username"]
node.override['rackspace']['cloud_credentials']['api_key']  = cloudcreds["api_key"]

node.override['rackspace_cloudmonitoring']['monitors_defaults']['alarm']['notification_plan_id'] = "npTechnicalContactsEmail"

include_recipe "rackspace_cloudmonitoring::agent"


# Define our monitors

cpu_critical_threshold = (node['cpu']['total'] * 4)
# Warning at x2 CPU count
cpu_warning_threshold = (node['cpu']['total'] * 2)

node.override['rackspace_cloudmonitoring']['monitors'] = {
  'cpu' =>  { 'type' => 'agent.cpu', },
  'load' => { 'type'  => 'agent.load_average',
    'alarm' => {
      'CRITICAL' => { 'conditional' => "metric['5m'] > #{cpu_critical_threshold}", },
      'WARNING'  => { 'conditional' => "metric['5m'] > #{cpu_warning_threshold}", },
    },
  },

  'disk' => {
    'type' => 'agent.disk',
    'details' => { 'target' => '/dev/xvda1'},
  },
  'root_filesystem' => {
    'type' => 'agent.filesystem',
    'details' => { 'target' => '/'},
  },
}

#
# Call the monitoring cookbook with our changes
#
include_recipe "rackspace_cloudmonitoring::monitors"