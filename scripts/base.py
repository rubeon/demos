#! python -u

import os
import sys
import time
import getopt
import json
import re
import datetime

from pprint import pprint
from pprint import pformat

import pyrax
import pyrax.exceptions as exc


class base:

    def __init__ (self, debug):
        self.message=None

        global DEBUG
        DEBUG=debug

        pyrax.set_setting("identity_type", "rackspace")
        pyrax.set_setting("region", _rax_region.upper())
        pyrax.set_credentials(os.environ['OS_USERNAME'], os.environ['OS_PASSWORD'])


        self.account_name = pyrax.identity.username

        self.cs = pyrax.cloudservers
        self.cf = pyrax.cloudfiles
        self.dns = pyrax.cloud_dns
        self.cdb = pyrax.cloud_databases
        self.cbs = pyrax.cloud_blockstorage
        self.clb = pyrax.cloud_loadbalancers
        self.cnw = pyrax.cloud_networks


    def check_cs_build(self, cs_obj):
        """ returns True when the cloud is built otherwise False """
        debug("check_cs_build start %s" % cs_obj.name)

        snew=self.cs.servers.get(cs_obj.id)
        return True if snew.status == "ACTIVE" else False

    def get_image(self):
        [ image ] = filter ( lambda x : bool(re.match("Ubuntu 10.04.*" , x.name)), self.cs.images.list())
        return image.id

    def get_flavor(self):
        [ f512 ] = filter( lambda x : x.ram==512 , self.cs.flavors.list())
        return f512.id

    def build_cloud_servers(self, count=0):
        debug("build_cloud_servers start")

        for i in xrange(0, count) :
            name= "%s-%d" % (self.name_prefix, i)

            # debug("name %s image %s flavor %s" % (name, self.image, self.flavor) )
            # pprint(self.files)

            s = self.cs.servers.create(name, self.image, self.flavor, files=self.files, nics=self.nics)
            self.servers.append(s)

    def delete_cs(self):
        debug("delete_cs start")

        for c in self.servers :
            c.delete()

    def get_servers(self):
        debug("get_servers start")

        wait = WaitingForTask(self.check_cs_build, self.servers)
        if wait.wait_for_tasks() == False:
            self.delete_cs()
            return None

        servers=[]
        for s in self.servers :
            servers.append(self.cs.servers.get(s.id))

        return servers

if __name__ == '__main__':
    challenge=ChallengeBase(1)
    challenge.run()
