#
# Cookbook Name:: sshd
# Recipe:: default
#
#

template "/etc/ssh/sshd_config" do
    source "sshd.erb"
    mode "0644"
    case node["platform"]
        when "redhat", "centos", "scientific", "fedora", "amazon"
            sftp_subsystem="/usr/libexec/openssh/sftp-server"
        when "debian", "ubuntu", "suse"
            sftp_subsystem="/usr/lib/openssh/sftp-server"
    end
    variables(
    :sshd_port => node['sshd']['port'],
    :x11_forwarding => node['sshd']['x11_forwarding'],
    :banner => node['sshd']['banner'],
    :permit_root => node['sshd']['permit_root'],
    :sftp_subsystem => sftp_subsystem
    )
end

template "/etc/issue.net" do
    source "issue.net.erb"
end

service "sshd" do
    supports :restart => true
    action [ :enable, :restart ]
end


iptables_rule "port_sshd"
