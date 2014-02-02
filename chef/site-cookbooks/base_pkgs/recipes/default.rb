#
# Cookbook Name:: base_pkgs
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#

node['package_list'].each do |pkg|
    package pkg do
        action :install
        ignore_failure false
    end
end
