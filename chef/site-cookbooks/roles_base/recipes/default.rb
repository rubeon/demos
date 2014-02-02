#
# Cookbook Name:: roles_base
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


include_recipe "remove_validation"

include_recipe "iptables::default"

include_recipe "base_pkgs::default"

include_recipe "motd::default"

include_recipe "sudo_config"
include_recipe "sudo"

include_recipe "users::sysadmins"

include_recipe "sshd::default"

include_recipe "cron::default"
include_recipe "cron_config::default"

include_recipe "logrotate::default"
include_recipe "logrotate_config::default"

include_recipe "sysctl"
include_recipe "sysctl_config"


