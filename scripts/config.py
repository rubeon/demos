#!/usr/bin/env python
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

import sys
import os

cloud_user = os.environ['OS_USERNAME']
cloud_api_key = os.environ['OS_PASSWORD']
cloud_region = os.environ['OS_REGION_NAME'].upper()
cloud_tenant = os.environ['OS_TENANT_NAME']

server_image = "f70ed7c7-b42e-4d77-83d8-40fa29825b85"
server_flavor = "performance1-1"
server_build_check_interval = 30
server_build_check_attempts = 10
server_ssh_keypair = "sri-key"
server_health_url = "/"
server_health_url_digest = "b0e7827137c2f936235e79ccce694d480786e744"

clb_name = "one.example.com"
clb_port = 80
clb_protcol = "HTTP"
clb_node_port = 80
clb_limit_sleep = 10
clb_build_check_interval = 30
clb_build_check_attempts = 10

chef_roles = "'role[base],role[web]'"
chef_env = "dev"
chef_ssh_user = "root"
chef_log_dir = "/home/sri/log/knife"
logobj = open("/home/sri/log/spinone.log", "a+")
print_to = logobj
