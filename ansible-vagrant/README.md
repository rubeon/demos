Single-machine VagrantFile:
===========================

To run the demos: 

* check out the directories ansible-multi and ansible-single.

* Import the CentOS x86_64 image:

        vagrant box add centos64 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box

The current release of Vagrant provides much better support for Ansible than previous
versions, such as parallelization.  Using versions older than 1.5 is not recommended, as it 
behaves differently than Ansible in production.

Vagrant includes built-in support for Ansible.  Here's a simple configuration file.


        $ cat Vagrantfile
        Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
          # …
          config.vm.box = "centos64"
          config.vm.provision "ansible" do |ansible|
            ansible.playbook = "provisioning/playbook.yml"
          end
        end



Example:


    $ cat provisioning/playbook.yml
    - hosts: all
      tasks:
        - name: ensure ntpd is at the latest version
          yum: pkg=ntp state=latest
        - name: make sure that ntpd is started and enabled
          service: name=ntpd state=started enabled=true
    $ vagrant up


    Bringing machine 'default' up with 'virtualbox' provider...
    [default] Importing base box 'centos64'...
    [default] Matching MAC address for NAT networking...
    [default] Setting the name of the VM...
    [default] Clearing any previously set forwarded ports...
    [default] Clearing any previously set network interfaces...
    [default] Preparing network interfaces based on configuration...
    [default] Forwarding ports...
    [default] -- 22 => 2222 (adapter 1)
    [default] Booting VM...
    [default] Waiting for machine to boot. This may take a few minutes...
    [default] Machine booted and ready!
    [default] Mounting shared folders...
    [default] -- /vagrant
    [default] Running provisioner: ansible...


    PLAY [all] ********************************************************************


    GATHERING FACTS ***************************************************************
    ok: [default]


    TASK: [ensure ntpd is at the latest version] **********************************
    ok: [default]


    TASK: [make sure that ntpd is started and enabled] ****************************
    changed: [default]


    PLAY RECAP ********************************************************************
    default                    : ok=3    changed=1    unreachable=0    failed=0
    $ vagrant ssh
    [vagrant@localhost ~]$ chkconfig --list ntpd

    ntpd                0:off     1:off     2:on     3:on     4:on     5:on     6:off
    [vagrant@localhost ~]$ service ntpd status
    ntpd (pid  2070) is running...
    [vagrant@localhost ~]$



Multiple-machine VagrantFile
============================

The following configuration file demonstrates how a set of machines can be orchestrated using
Vagrant and Ansible.

Notice the use of fixed IP addresses and machine hostnames; these will be added to the Ansible 
inventory file that is maintained by Vagrant.


    VAGRANTFILE_API_VERSION = "2"

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      config.vm.box = "centos64"

      config.vm.define 'machine2' do |machine|
        machine.vm.hostname = 'machine2'
        machine.vm.network "private_network", ip: "192.168.77.22"
      end

      config.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/ntp.yml"
        ansible.sudo = true
      end

      config.vm.define 'machine1' do |machine|
        machine.vm.hostname = 'machine1'
        machine.vm.network "private_network", ip: "192.168.77.21"
        # putting the ansible stanza inside this VM tricks vagrant's outside-in ordering into
        # running this last.
        config.vm.provision "ansible" do |ansible|
          ansible.playbook = "provisioning/ntp.yml"
          ansible.sudo = true
          # the following line tells ansible to run the provisioner against
          # all machines in the inventory file; default filter is the current config.vm
          ansible.limit = 'all'
        end
      end

    end

    $ vagrant  up
    Bringing machine 'machine2' up with 'virtualbox' provider...
    Bringing machine 'machine1' up with 'virtualbox' provider...
    ==> machine2: Importing base box 'centos64'...
    ==> machine2: Matching MAC address for NAT networking...
    ==> machine2: Setting the name of the VM: ansible-multi_machine2_1403020085175_79900
    ==> machine2: Clearing any previously set network interfaces...
    ==> machine2: Preparing network interfaces based on configuration...
        machine2: Adapter 1: nat
        machine2: Adapter 2: hostonly
    ==> machine2: Forwarding ports...
        machine2: 22 => 2222 (adapter 1)
    ==> machine2: Booting VM...
    ==> machine2: Waiting for machine to boot. This may take a few minutes...
        machine2: SSH address: 127.0.0.1:2222
        machine2: SSH username: vagrant
        machine2: SSH auth method: private key
        machine2: Warning: Connection timeout. Retrying...
    ==> machine2: Machine booted and ready!
    ==> machine2: Checking for guest additions in VM...
    ==> machine2: Setting hostname...
    ==> machine2: Configuring and enabling network interfaces...
    ==> machine2: Mounting shared folders...
        machine2: /vagrant => /Users/me/Varmints/ansible-multi
    ==> machine1: Importing base box 'centos64'...
    ==> machine1: Matching MAC address for NAT networking...
    ==> machine1: Setting the name of the VM: ansible-multi_machine1_1403020156476_60852
    ==> machine1: Fixed port collision for 22 => 2222. Now on port 2200.
    ==> machine1: Clearing any previously set network interfaces...
    ==> machine1: Preparing network interfaces based on configuration...
        machine1: Adapter 1: nat
        machine1: Adapter 2: hostonly
    ==> machine1: Forwarding ports...
        machine1: 22 => 2200 (adapter 1)
    ==> machine1: Booting VM...
    ==> machine1: Waiting for machine to boot. This may take a few minutes...
        machine1: SSH address: 127.0.0.1:2200
        machine1: SSH username: vagrant
        machine1: SSH auth method: private key
        machine1: Warning: Connection timeout. Retrying...
        machine1: Warning: Remote connection disconnect. Retrying...
    ==> machine1: Machine booted and ready!
    ==> machine1: Checking for guest additions in VM...
    ==> machine1: Setting hostname...
    ==> machine1: Configuring and enabling network interfaces...
    ==> machine1: Mounting shared folders...
        machine1: /vagrant => /Users/me/Varmints/ansible-multi
    ==> machine1: Running provisioner: ansible...


    PLAY [all] ********************************************************************


    GATHERING FACTS ***************************************************************
    ok: [machine1]
    ok: [machine2]


    TASK: [ensure ntpd is at the latest version] **********************************
    ok: [machine1]
    ok: [machine2]


    TASK: [make sure that ntpd is started and enabled] ****************************
    changed: [machine1]
    changed: [machine2]


    TASK: [ensure apache is installed and latest version] *************************
    changed: [machine1]
    changed: [machine2]


    TASK: [make sure apache is started and enabled] *******************************
    changed: [machine1]
    changed: [machine2]


    PLAY RECAP ********************************************************************
    machine1                   : ok=5    changed=3    unreachable=0    failed=0
    machine2                   : ok=5    changed=3    unreachable=0    failed=0

