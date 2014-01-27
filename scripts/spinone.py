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

utils.log_msg("Starting spinone", "INFO", config.print_to)

opts, args = getopt.getopt(sys.argv[1:], "hs:d", ["help",
                                                  "server-name=",
                                                  "debug",
                                                  "remove-after"])

create_srv = ""
remove_after = False
debug_flag = False
for o, a in opts:
    if o in ("-s", "--server-name"):
        server_name = a
    else:
        if o in ("-d", "--debug"):
            debug_flag = True
        else:
            if o in ("--remove-after"):
                remove_after = True
            else:
                assert False, "unhandled option"

pyrax.set_setting("identity_type", "rackspace")
pyrax.set_setting("region", config.cloud_region)
try:
    pyrax.set_credentials(config.cloud_user,
                          config.cloud_api_key,
                          region=config.cloud_region)
except exc.AuthenticationFailed:
    utils.log_msg(" ".join(["Pyrax auth failed using", config.cloud_user]),
                  "ERROR",
                  config.print_to)

utils.log_msg(" ".join(["Authenticated using", config.cloud_user]),
              "INFO",
              config.print_to)

cs = pyrax.cloudservers

if cs is None:
    utils.log_msg("Failed to get cloud server object",
                  "ERROR",
                  config.print_to)
else:
    utils.log_msg(" ".join(["Creating server", server_name]),
                  "INFO",
                  config.print_to)

    new_srv = cs.servers.create(server_name,
                                config.server_image,
                                config.server_flavor,
                                key_name=config.server_ssh_keypair)
    root_pass = new_srv.adminPass

    pyrax.utils.wait_until(new_srv, "status", ["ACTIVE", "ERROR"],
                           interval=config.server_build_check_interval,
                           callback=None,
                           attempts=config.server_build_check_attempts,
                           verbose=False,
                           verbose_atts="progress")

    #get server status again
    srv = cs.servers.get(new_srv.id)

    if srv.status == "ACTIVE":
        utils.log_msg("%s,%s,%s,%s,%s,%s" % (srv.name,
                                             srv.id,
                                             srv.accessIPv4,
                                             srv.networks["private"][0],
                                             root_pass,
                                             srv.status),
                      "INFO", config.print_to)

        # Now we bootstrap with knife

        cmdargs = ["knife",
                   "bootstrap",
                   "-r ", config.chef_roles,
                   "--node-name", srv.name,
                   "--environment", config.chef_env,
                   "--ssh-user", config.chef_ssh_user,
                   srv.accessIPv4]

        utils.log_msg(" ".join(cmdargs),
                         "INFO", config.print_to)
        os.system(" ".join(cmdargs))

        # Add to load balancer pool
        clb = pyrax.cloud_loadbalancers
        if clb is None:
            utils.log_msg("Failed to get cloud load balancer object",
                          "ERROR", config.print_to)
        else:
            lb_name = config.clb_name
            not_found = True
            for lb in clb.list():
                if lb.name == lb_name:
                    utils.log_msg(" ".join(["Load balancer pool",
                                           lb_name, "found"]),
                                  "INFO", config.print_to)

                    skip_node = False
                    not_found = False
                    if hasattr(lb, 'nodes'):
                        for node in lb.nodes:
                            if node.address == srv.networks["private"][0]:
                                skip_node = True

                    if skip_node:
                        utils.log_msg("Skipping node as it already exists",
                                      "INFO", config.print_to)
                    else:
                        utils.log_msg(" ".join(["Adding node",
                                               srv.name,
                                               srv.networks["private"][0]]),
                                      "INFO", config.print_to)
                        node = clb.Node(address=srv.networks["private"][0],
                                        port=config.clb_node_port,
                                        condition="ENABLED")
                        lb.add_nodes([node])
                        pyrax.utils.wait_until(lb, "status", "ACTIVE",
                                               interval=config.clb_build_check_interval,
                                               attempts=config.clb_build_check_attempts,
                                               verbose=False)

            if not_found:
                utils.log_msg(" ".join(["LB VIP not found. Creating new VIP",
                                       lb_name]),
                              "INFO", config.print_to)

                node = clb.Node(address=srv.networks["private"][0],
                                port=config.clb_node_port,
                                condition="ENABLED")
                vip = clb.VirtualIP(type="PUBLIC")
                lb = clb.create(lb_name, port=config.clb_port,
                                protocol=config.clb_protcol,
                                nodes=[node],
                                virtual_ips=[vip])
                pyrax.utils.wait_until(lb, "status", "ACTIVE",
                                       interval=config.clb_build_check_interval,
                                       attempts=config.clb_build_check_attempts,
                                       verbose=False)

                lb.add_health_monitor(type="HTTP", delay=10, timeout=10,
                                      attemptsBeforeDeactivation=3, path="/status.html",
                                      statusRegex="^[234][0-9][0-9]$",
                                      bodyRegex=".* _ALLOK_ .*")
                pyrax.utils.wait_until(lb, "status", "ACTIVE",
                                       interval=config.clb_build_check_interval,
                                       attempts=config.clb_build_check_attempts,
                                       verbose=False)

    else:
        utils.log_msg("Server not ACTIVE", "ERROR", config.print_to)
        #delete
