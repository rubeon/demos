
Ansible demo
=====

Demonstrates the use of Ansible to configure common things. This is similar to the Chef demo

**Base**
  * Installed a base set of packages
  * Created the necessary users and sudo privileges
  * Configure the firewall
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

Running the demo
=====
 * Clone the repo

 * Get some servers on Rackspace cloud or anywhere. Ideally we need 2 and the db one needs to be named website-one-db01 as we use it in the plays to get IPs etc. Make sure you can login to the servers with ssh keys.

 * Create an inventory file.

```
[web]
website-one-web01 ansible_ssh_host=162.13.187.100 ansible_ssh_user=root

[app]
website-one-web01 ansible_ssh_host=162.13.187.100 ansible_ssh_user=root

[db]
website-one-db01 ansible_ssh_host=134.213.50.179 ansible_ssh_user=root
``` 

 * Run a test make sure you can reach them
```
ansible -i inventory_test -m ping all
```

 * Run the base playbook
```
ansible-playbook -i inventory_test -c paramiko base.yml
```

 * Now run the db playbook
```
ansible-playbook -i inventory_test  -c paramiko db.yml
```

 * Run the web and app playbooks

```
ansible-playbook -i inventory_test  -c paramiko web.yml
ansible-playbook -i inventory_test  -c paramiko app.yml
```

* Test the IP of the web node. This will be running a PHP website
```
/
/world.php
/world-view.php
```

* Test the IP of the web node. This will be running a Java app
```
/guess/
/helloworld/
```


Using Vagrant
=====
TODO


Ansible and RAX setup
=====

 * Create a ansible home dir and an inventory dir

```
mkdir ansible
mkdir ansible\inventory
```

 * Create a localhost inventory file called 'ansible_hosts' with the following

```
[localhost]
localhost ansible_connection=local
```

 * Copy the rax.py plugin to this folder and make sure this set to executable. Ansible will read this folder for all inventory configuration files and an implicit behaviour is to treat executable files as dynamic inventory plugins and non-executable files as INI files

```
cd ansible\inventory
wget https://raw.githubusercontent.com/ansible/ansible/devel/plugins/inventory/rax.py
chmod+x rax.py
```

 * Create a credentials file in the pyrax format and call it creds_pyrax (https://github.com/rackspace/pyrax/blob/master/docs/getting_started.md#authenticating)

```
[rackspace_cloud]
username = 
api_key = 
```

 * Set the environment
```
export RAX_CREDS_FILE=/Users/sri/data/rack/git/RackspaceDevOps/demos/ansible/creds_pyrax
export RAX_REGION=lon
```

 * Test it
```
cd ansible\inventory
./rax.py --list
```

 * Now you can load your inventory from Rackspace
```
ansible all -i inventory/ -m setup
```

ansible localhost -m rax -a "name=test_web01 flavor=performance1-1 image=042395fc-728c-4763-86f9-9b0cacb00701 wait=yes" -c local


Troubleshooting
=====

 * Set this to leave the scripts on servers

ANSIBLE_KEEP_REMOTE_FILES=1


 * List variables
```
ansible -m setup test -i inventory
```

References
=====
http://docs.ansible.com/guide_rax.html
