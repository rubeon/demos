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

# cloud auth data will be pulled from environment
cloud_user = os.environ['OS_USERNAME']
cloud_api_key = os.environ['OS_PASSWORD']
cloud_region = os.environ['OS_REGION_NAME'].upper()
cloud_tenant = os.environ['OS_TENANT_NAME']

# server build configuration
server_image = "f70ed7c7-b42e-4d77-83d8-40fa29825b85"
server_flavor = "performance1-1"
server_build_check_interval = 30
server_build_check_attempts = 10
server_ssh_keypair = "demo-key"
server_health_url = "/health-check.php"
server_health_url_digest = "6783deae6fb363c7bd7fc81565e5c3aad7ccdb34"

# load balancer configuration
clb_name = "one.example.com"
clb_port = 80
clb_protcol = "HTTP"
clb_node_port = 80
clb_limit_sleep = 10
clb_build_check_interval = 30
clb_build_check_attempts = 10

# chef settings
chef_roles = "'role[base],role[web]'"
chef_env = "dev"
chef_ssh_user = "root"
chef_log_dir = "/home/sri/log/knife"

#print_to = sys.stdout #use this to print to screen
print_color = False
logobj = open("/home/sri/log/build.log", "a+")
print_to = logobj



