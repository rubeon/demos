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

pyrax.set_setting("identity_type", "rackspace")
creds_file = os.path.expanduser("~/pyrax.cfg")
pyrax.set_credential_file(creds_file)
cs = pyrax.connect_to_cloudservers(region="LON")

flvs = cs.flavors.list()
for flv in flvs:
    print "Name:", flv.name
    print " ID:", flv.id
    print " RAM:", flv.ram
    print " Disk:", flv.disk
    print " VCPUs:", flv.vcpus
    print

