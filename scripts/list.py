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

import os
import sys
import getopt
import getopt
import pyrax
import utils
import config
import pprint


pyrax.set_setting("identity_type", "rackspace")
pyrax.set_setting("region", config.cloud_region)
try:
    pyrax.set_credentials(config.cloud_user,config.cloud_api_key,region=config.cloud_region)
except exc.AuthenticationFailed:
    utils.log_msg("Pyrax auth failed using " + config.cloud_user, "ERROR", config.print_to)

utils.log_msg("Authenticated using " + config.cloud_user,"INFO",config.print_to)

cs = pyrax.cloudservers

if cs == None:
    utils.log_msg("Failed to get cloud server object", "ERROR", config.print_to)
else:
    servers = cs.servers.list()
    for srv in servers:
        if srv.name == "test00":
            #srv.delete()

