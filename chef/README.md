Chef Cookbooks
=====

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



Knife commands
=====

knife rackspace server create -r  'role[base],role[web]' --server-name web101 --node-name web101 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 --flavor  performance1-1 --environment prod --rackspace-region lon --no-host-key-verify

n=web101; nova delete $n; knife node delete -y $n; knife client delete -y $n; 

knife rackspace server create -r  'role[base],role[web],role[app]' --server-name web102 --node-name web102 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 --flavor  performance1-1 --environment prod --rackspace-region lon --no-host-key-verify

n=web102; nova delete $n; knife node delete -y $n; knife client delete -y $n; 


knife rackspace server create --server-name t100 --node-name t100 --image f70ed7c7-b42e-4d77-83d8-40fa29825b85 --flavor  performance1-1 --environment prod --rackspace-region lon --no-host-key-verify


Todo
=====

 * Reformat them to follow https://github.com/rackspace-cookbooks/contributing guidelines
 * Build Chef Test Specs