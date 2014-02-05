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
import hashlib
import urllib2
import time


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

server_log_id = "Node:" + server_name

utils.log_msg(" ".join([server_log_id, "Starting spinone"]),
              "INFO",
              config.print_to)


pyrax.set_setting("identity_type", "rackspace")
pyrax.set_setting("region", config.cloud_region)
try:
    pyrax.set_credentials(config.cloud_user,
                          config.cloud_api_key,
                          region=config.cloud_region)
except pyrax.exc.AuthenticationFailed:
    utils.log_msg(" ".join([server_log_id, "Pyrax auth failed using", config.cloud_user]),
                  "ERROR",
                  config.print_to)

utils.log_msg(" ".join([server_log_id, "Authenticated using", config.cloud_user]),
              "INFO",
              config.print_to)

cs = pyrax.cloudservers

if cs is None:
    utils.log_msg(" ".join([server_log_id, "Failed to get cloud server object"]),
                  "ERROR",
                  config.print_to)
else:
    utils.log_msg(" ".join([server_log_id, "Creating server", server_name]),
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
        utils.log_msg("%s,%s,%s,%s,%s" % (server_log_id,
                                             srv.name,
                                             srv.accessIPv4,
                                             srv.networks["private"][0],
                                             srv.status),
                      "INFO",
                      config.print_to)

        utils.log_msg(" ".join([server_log_id, "Bootstrapping Chef", "Environment =", config.chef_env,"Roles =",config.chef_roles]),
                      "INFO", config.print_to)

        # Now we bootstrap with knife

        knife_log = "".join([config.chef_log_dir , "/" , srv.name , ".log"])
        cmdargs = ["knife",
                   "bootstrap",
                   "-r ", config.chef_roles,
                   "--node-name", srv.name,
                   "--environment", config.chef_env,
                   "--ssh-user", config.chef_ssh_user,
                   "--no-host-key-verify",
                   srv.accessIPv4,
                   ">" + knife_log,
                   "2>" + knife_log]

        os.system(" ".join(cmdargs))
        utils.log_msg(" ".join([server_log_id, "Bootstrapping Chef", "Complete"]),
                      "INFO", config.print_to)

        try:
            url = "http://" + srv.accessIPv4 + config.server_health_url
            urlobj = urllib2.urlopen(url,timeout = 5 )
            urldata = urlobj.read()
            sha1 = hashlib.sha1()
            sha1.update(urldata)
            if sha1.hexdigest() != config.server_health_url_digest:
                utils.log_msg(" ".join([server_log_id, "Health test failed.Deleting cloud server"]),
                              "ERROR", config.print_to)
                # need delete code
            else:
                utils.log_msg(" ".join([server_log_id, "Health test passed. Loading load balancer config"]),
                              "INFO",
                              config.print_to)

                # Add to load balancer pool
                clb = pyrax.cloud_loadbalancers
                if clb is None:
                    utils.log_msg(" ".join([server_log_id, "Failed to get load balancer object"]),
                                  "ERROR", config.print_to)
                else:
                    lb_name = config.clb_name
                    vip_found = False
                    lb_error = False
                    attempts = 5
                    while True:
                        if attempts == 0:
                            utils.log_msg(" ".join([server_log_id, "Max attempts reached to get load balancer listing"]),
                                          "ERROR", config.print_to)
                            lb_error = True
                            break
                        try:
                            for lb in clb.list():
                                if lb.name == lb_name:
                                    utils.log_msg(" ".join([server_log_id, "Load balancer pool",
                                                            lb_name, "found"]),
                                                    "INFO",
                                                    config.print_to)
                                    lb_id = lb.id
                                    vip_found = True
                                    break
                        except (pyrax.exceptions.OverLimit,pyrax.exceptions.ClientException) as e:
                            time.sleep(config.clb_limit_sleep)
                            continue
                            attempts = attempts - 1
                        break

                    if vip_found == True and lb_error == False:
                        skip_node = False
                        attempts = 5
                        while True:
                            if attempts == 0:
                                utils.log_msg(" ".join([server_log_id, "Max attempts reached to get load balancer node list"]),
                                              "ERROR", config.print_to)
                                lb_error = True
                                break
                            try:
                                lb = clb.get(lb_id)
                                if hasattr(lb, 'nodes'):
                                    for node in lb.nodes:
                                        if node.address == srv.networks["private"][0]:
                                            skip_node = True
                                if skip_node:
                                    utils.log_msg(" ".join([server_log_id, "Skipping node as it already exists"]),
                                                  "INFO",
                                                  config.print_to)
                                else:
                                    node = clb.Node(address=srv.networks["private"][0],
                                                port=config.clb_node_port,
                                                condition="ENABLED")
                                    utils.log_msg(" ".join([server_log_id, "Adding node to LB"]),
                                                  "INFO",
                                                  config.print_to)
                                    attempts = 5
                                    while True:
                                        if attempts == 0:
                                            utils.log_msg(" ".join([server_log_id, "Max attempts reached to get load balancer listing"]),
                                                        "ERROR", config.print_to)
                                            lb_error = True
                                            break
                                        try:
                                            lb = clb.get(lb_id)
                                            pyrax.utils.wait_until(lb, "status", "ACTIVE",
                                                       interval=config.clb_build_check_interval,
                                                       attempts=config.clb_build_check_attempts,
                                                       verbose=False)
                                            lb.add_nodes([node])

                                        except (pyrax.exceptions.OverLimit,pyrax.exceptions.ClientException) as e:
                                            time.sleep(config.clb_limit_sleep)
                                            continue
                                            attempts = attempts - 1
                                        break

                            except pyrax.exceptions.OverLimit,e:
                                time.sleep(config.clb_limit_sleep)
                                continue
                                attempts = attempts - 1
                            break

        except urllib2.URLError:
            utils.log_msg(" ".join([server_log_id, "Health test failed.Deleting cloud server"]),
                          "ERROR", config.print_to)
            #new_srv.delete()

    else:
        utils.log_msg(" ".join([server_log_id, "Server not ACTIVE"]),
        "ERROR",
        config.print_to)
        new_srv.delete()
