
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


Populate the Chef Server
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
servername=websiteone_web01; knife rackspace server create  \
 --server-name $servername \
 --node-name $servername \
 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 \
 --flavor  performance1-1 \
 --rackspace-region lon  \
 --no-host-key-verify  \
 -r 'role[base],role[db]' -V
```

 * Build a server with web role
```
servername=websiteone_web01; knife rackspace server create  \
 --server-name $servername \
 --node-name $servername \
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
servername=websiteone_webapp01; knife rackspace server create  \
 --server-name $servername \
 --node-name $servername \
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

Using Vagrant
=====

 * Ensure you have vagrant vagrant-rackspace vagrant-omnibus and vagrant-yaml plugins. Ruby 1.9.3 as well (Ruby 2.0 has issues)
```
sudo gem install vagrant vagrant-rackspace vagrant-yaml
```

 * Edit vagrant_config.yaml to set the box name and urls etc. Also set the rackspace cloud credentials if you want to use vagrant with Rackspace cloud. Likewise set your SSH keys in the vagrant_config.yaml.  Vagrant by default uses a private key that is available as part of the package. This is not ideal for public cloud servers.


 * To run Locally

```
vagrant up
```

 * Using Rackspace cloud
```
vagrant up --provider rackspace
```

 * Troubleshooting. Set debug and run
```
export VAGRANT_LOG=debug
```

