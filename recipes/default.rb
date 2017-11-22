#
# Cookbook:: multi-platform-ntp-one-recipe
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Platform specific settings
case node['platform']
when 'redhat'
  # Red Hat settings (ntpd)
  service_name = 'ntpd'
  service_action = [:start, :enable]

when 'aix'
  # AIX settings
  service_name = 'xntpd'
  service_action = [:start]
end

# Install package if RHEL
package 'ntp' do
  only_if { node['platform'] == 'redhat' }
end

# Configure NTP configuration file: same path on both if using ntpd on RHEL
template '/etc/ntp.conf' do
  owner 'root'
  group node['root_group'] # may ohai keep us forever sane
  mode '0644'
  source 'ntp.conf.erb' # rely on source being in platform directory of templates
  notifies :restart, "service[#{service_name}]"
end

# Setup service: different name and actions per platform here
service service_name do
  action service_action
end
