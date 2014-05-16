#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright 2012 Rackspace

# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import os
import pyrax
import random
import string
from pprint import pprint
from time import sleep
import sys


# Set pyrax credentials
pyrax.set_setting("identity_type", "rackspace")
creds_file = os.path.expanduser("pyrax-rc.cfg")
pyrax.set_credential_file(creds_file,region='LON')
cs = pyrax.cloudservers


# Some defaults
IMAGE_ID="f70ed7c7-b42e-4d77-83d8-40fa29825b85" #Centos 6.4
FLAVOR_ID="performance1-1"
SERVER_STRING="rctest"
SLEEP_INTERVAL=30 #seconds
MAX_TIME=300 #seconds


#create server
server_name=SERVER_STRING + '-' + ''.join(random.choice(string.lowercase) for i in range(8))
print "Creating server ", server_name
new_srv = cs.servers.create(server_name, IMAGE_ID, FLAVOR_ID)
pyrax.utils.wait_for_build(new_srv)


rc_complete = 0
total_sleep = 0

#get server status again
srv = cs.servers.get(new_srv.id)

if srv.status == "ACTIVE":

    print "Server status : Active"
    print "%s::%s::%s::%s" % (srv.name , srv.id, srv.accessIPv4, srv.status)
    print "Waiting for Rackconnect automation..."

    #pprint(vars(srv))


    #loop and check server metadata
    while rc_complete == 0 :
        #pprint(srv.metadata)
        for key, value in srv.metadata.items() :
            #print key, "=", value
            if key == 'rackconnect_automation_status':
                if value == 'DEPLOYED':
                    rc_complete = 1
                    print "Rackconnect automation complete"

            
        if rc_complete == 0 :
            print "Sleeping ", SLEEP_INTERVAL, " seconds"
            sleep(SLEEP_INTERVAL)
            total_sleep = total_sleep + SLEEP_INTERVAL
            if total_sleep >= MAX_TIME:
                print "Max time reached. Aborting"
                sys.exit(-1)
            srv = cs.servers.get(new_srv.id)
else:
    print "ERROR: Server not ACTIVE"
