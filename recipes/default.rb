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

# Install package if Red Hat
package 'ntp' do
  only_if { node['platform'] == 'redhat' }
end

# NTP configuration file: same path on both if using ntpd on Red Hat
template '/etc/ntp.conf' do
  owner 'root'
  group node['root_group'] # may ohai keep us forever sane
  mode '0644'
  source 'ntp.conf.erb' # rely on source being in platform directory of templates
  notifies :restart, "service[#{service_name}]"
end

# Setup service: different name and actions per platform here
# Red Hat is easy, we can just do :start, :enable
# AIX is a little more messy.  We can do :start, but enable is handled via inittab
service service_name do
  action service_action
end

# AIX ONLY: enable xntpd via inittab
execute 'add xntpd to inittab on aix' do
  command 'mkitab ntpd:2:wait:/usr/bin/startsrc -x xntpd > /dev/null 2>&1'
  not_if 'lsitab ntpd'
end
