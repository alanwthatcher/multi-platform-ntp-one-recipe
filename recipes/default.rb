#
# Cookbook:: multi-platform-ntp-one-recipe
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Platform specific settings
case node['platform']
when 'redhat'
  # Red Hat settings differ by release now
  case node['platform_version'].split('.')[0]
  when '6'
    # RHEL 6 settings: ntpd
    pakcage_name = 'ntp'
    service_name = 'ntpd'
    config_source = 'ntp.conf.erb'
    config_path = '/etc/ntp.conf'
    service_action = [:start, :enable]
    
  when '7'
    # RHEL 7 settings: chrony
    package_name = 'chrony'
    service_name = 'chronyd'
    config_source = 'chrony.conf.erb'
    config_path = '/etc/chrony.conf'
    service_action = [:start, :enable]
  end
  
when 'aix'
  # AIX settings
  service_name = 'xntpd'
  config_source = 'ntpd.conf.erb'
  config_path = '/etc/ntp.conf'
  service_action = [:start]
end

# Install package if Red Hat
package package_name do
  only_if { node['platform'] == 'redhat' }
end

# NTP configuration file: same path on both if using ntpd on Red Hat
template config_path do
  owner 'root'
  group node['root_group'] # may ohai keep us forever sane
  mode '0644'
  source config_source # rely on source being in platform directory of templates
  notifies :restart, "service[#{service_name}]"
end

# Setup service: different name and actions per platform here
# Red Hat is easy, we can just do :start, :enable
# AIX is a little more messy.  We can do :start, but enable is handled via inittab
service service_name do
  action service_action
end

# AIX ONLY: enable xntpd via inittab
# We could certainly use a better custom provider here, as in the aix community cookbook
#   but for the sake of simplicity:
execute 'add xntpd to inittab on aix' do
  command 'mkitab ntpd:2:wait:/usr/bin/startsrc -x xntpd > /dev/null 2>&1'
  not_if 'lsitab ntpd'
end
