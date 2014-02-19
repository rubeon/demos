
Chef Cookbooks
=====

Demonstrates the use of chef to configure common things.   Base role does the usual basic stuff like iptables etc. DB role installs mysql and load the sample world database. Web role installs apache and loads a php app. App role installs Jboss and deploys a Jboss application.

**Base**
  * Configure the firewall
  * Installed a base set of packages
  * Created the necessary users and sudo privileges
  * Configure  SSH service
  * Configure logging
  * Tweak other system(sysctl) settings

**Web**
  * Install the Apache web server
  * Deployed a sample website

**App**
  * Install Jboss application server
  * Deployed Java applications


**DB**
  * Install MySQL database
  * Deployed a sample database


How to use it
=====

 * Clone the demo repo
```
git clone https://github.com/bigcloudsolutions/demos
```

 
 * Switch to the demo_v1 branch
```
git checkout demo_v1
```

 * Load environments
```
knife environment from file chef/environments/*
```

 * Load roles
```
knife role from file chef/roles/*
```

* Load data bags
```
knife data bag create config
knife data bag from file passwords chef/data_bags/config/passwords.json
```

 * Configure Knife to use the enckey in the data_bags folder. This is needed for the encrypted data bags.

 * Upload the cookbooks
```
knife cookbook upload -a
```

 * Build a server with DB role
```
knife rackspace server create  \
 --server-name websiteone_db \
 --node-name websiteone_db \
 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 \
 --flavor  performance1-1 \
 --rackspace-region lon  \
 --no-host-key-verify  \
 -r 'role[base],role[db]' -V
```

 * Build a server with web role
```
knife rackspace server create  \
 --server-name websiteone_web01 \
 --node-name websiteone_web01 \
 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 \
 --flavor  performance1-1 \
 --rackspace-region lon  \
 --no-host-key-verify  \
 -r 'role[base],role[web]' -V
```

 * Test the IP of the web node. This will be running a PHP website
```
/
/world.php
/world-view.php
```

 * [Optional] - Build a server with web app role
```
knife rackspace server create  \
 --server-name websiteone_web01 \
 --node-name websiteone_web01 \
 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 \
 --flavor  performance1-1 \
 --rackspace-region lon  \
 --no-host-key-verify  \
 -r 'role[base],role[web],role[app]' -V
```

 * Test the IP of the web node. This will be running a Java app
```
/guess/
/helloworld/
```
 