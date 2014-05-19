
# Ansible demo


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


## Ansible and RAX setup


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
export RAX_CREDS_FILE=/Users/sri/data/rack/git/bigcloudsolutions/demos/ansible/creds_pyrax
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
ANSIBLE_KEEP_REMOTE_FILES=1


List variables
ansible -m setup test -i inventory

## References


http://docs.ansible.com/guide_rax.html
