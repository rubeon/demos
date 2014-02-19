#
# Cookbook Name:: roles_base
# Recipe:: default
#
# Copyright 2014, 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


include_recipe "remove_validation"

###  Firewall settings

include_recipe 'rackspace_iptables'
add_iptables_rule('INPUT', '-s 0.0.0.0 -p tcp --dport 3333 -j ACCEPT')


### Create users. This can be loaded from a data bag as well
include_recipe "rackspace_user::rack_user"

node.default['rackspace_user']['users']['sri'] = {
  "enabled" => true,  
  "sudo" => true,  
  "sudo_nopasswd" => true,  
  "manage_home" => true,  
  "password" => "$1$eWNk/D4d$JBuf3LRnbELIgG2bjJsmk/",  
  "note" => "Hello",  
  "home" => "/home/sri",  
  "shell" => "/bin/bash",  
  "groups" => ["sysadmins", "dba"],
  "authorized_keys" => [  
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8qZ1W3X+VFSoK8741Pew4B8v7MOhJE9nDAAdMMtzs1xeAmlqs09kqjyIAvRsoeKL/qrLQE2nE/JRpkCOXf99MhdQIeJwXFj3lb1SdIsP7cDuLbtl95EygSjSf5ip+pswJl9BeKRvOPpu5ksX1okoSvXGj2LaTLsFZ1hkzf0S7OHycHRHgpb5v5flzVvCCyW9Vh5WjZHOh8QnNoNWhlA9ljLt/nOIveALxHbHitbX7zirVC0DQqVhwC1d1pHeIbFpLgLoDQV8vghRWyPjPnfS8AyFTs2CEzAnm6UtCEO/Vw1s/UTm9/qHUNS5cRvCn783rvFPQ6motglazv9igvF7cQ== sri@devnull"
  ]
}

include_recipe "rackspace_user::additional_users"

### Sudo 
node.default['rackspace_sudo']['config']['authorization']['sudo']['include_sudoers_d'] = true
include_recipe "rackspace_sudo::default"


### NTP
node.default['rackspace_ntp']['config']['servers']  = [ "time.lon.rackspace.com", "time2.lon.rackspace.com", "0.pool.ntp.org"]
include_recipe "rackspace_ntp::default"


### SSH
node.default['rackspace_openssh']['config']['server']['x11_forwarding'] = 'no'
node.default['rackspace_openssh']['config']['server']['Port'] = '3333'
include_recipe "rackspace_openssh::default"


### Helper cookbooks
include_recipe "rackspace_apt::default"
include_recipe "rackspace_yum::default"

### Install other packages
include_recipe "base_pkgs::default"


### Update motd
include_recipe "rackspace_motd::default"

### Cron
include_recipe "cron::default"
# Set a cron job for chef client
cron "chef" do
  hour "*"
  minute "15"
  day "*"
  month "*"
  command "chef-client "
end

### Log config
include_recipe "rackspace_logrotate::default"

case node["platform"]
        when "redhat", "centos", "fedora"
            logrotate_app "syslog" do
                cookbook "rackspace_logrotate"
                options ["missingok", "delaycompress", "notifempty"]
                path ["/var/log/secure", "/var/log/messages", "/var/log/cron", "/var/log/maillog", "/var/log/spooler"]
                postrotate <<-EOF
                    /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
                EOF
                frequency "daily"
                rotate 30
                create "644 root adm"
            end
        when "debian", "ubuntu"
            logrotate_app "rsyslog" do
                cookbook "rackspace_logrotate"
                options ["missingok", "delaycompress", "notifempty"]
                path ["/var/log/syslog", "/var/log/mail.*", "/var/log/daemon.log", "/var/log/mail.log", "/var/log/cron.log", "/var/log/user.log", "/var/log/messages"]
                postrotate <<-EOF
                    /bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true
                EOF
                frequency "daily"
                rotate 30
                create "644 root adm"
            end
end



### Sysctl config
node.default['rackspace_sysctl']['config']['vm.swappiness'] = 10
include_recipe "rackspace_sysctl::default"

