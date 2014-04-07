
Ansible demo
=====

Demonstrates the use of Ansible to configure common things. This is similar to the Chef demo


**Ansible and RAX setup **
====

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
chnod+x rax.py
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

Reference
====

http://docs.ansible.com/guide_rax.html
