#
# Cookbook Name:: update_hosts
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

hosts = partial_search(:node, '*:*',
   :keys => {
              'domain' => ['domain'],
              'fqdn' => [ 'fqdn' ],
              'hostname'   => [ 'hostname' ],
              'ip'   => [ 'ipaddress' ]
            })

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hosts => hosts,
    :mydomain => node['mydomain'],
    :region => node['rackspace']['region']
  )
end

if (node["ipaddress"] && node["ipaddress"] != nil)
   # Add itself if missing
   hostsfile_entry node['ipaddress'] do
      hostname node['hostname'] + "." +  node['rackspace']['region'] + "." + node['mydomain']
      action    :create_if_missing
   end
end rescue NoMethodError


