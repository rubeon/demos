#
# Cookbook Name:: manage_logrotate
# Recipe:: default
#
# Copyright 2013, 
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


case node["platform"]
        when "redhat", "centos", "scientific", "fedora", "amazon"
            logrotate_app "syslog" do
                cookbook "logrotate"
                options ["missingok", "delaycompress", "notifempty"]
  	        path ["/var/log/secure", "/var/log/messages", "/var/log/cron", "/var/log/maillog", "/var/log/spooler"]
                postrotate <<-EOF
                    /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
                EOF
                frequency "daily"
                rotate 30
                create "644 root adm"
            end
        when "debian", "ubuntu", "suse"
            logrotate_app "rsyslog" do
                cookbook "logrotate"
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
