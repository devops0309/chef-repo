#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
# Cookbook:: mongodb
# Recipe:: hostname
#

bash 'update hostname for each node' do
  not_if 'grep -i mongo /etc/hostname'
  code <<-EOH
  echo "#{node.name}" > /etc/hostname
  hostname #{node.name}
  EOH
 end

 template "/etc/rc.local" do
 source 'rc.local.erb'
 owner "root"
 group "root"
 mode '0755'
 end

 # bash "updating variables in rc.local script" do
 #   not_if 'grep -i mongo /etc/rc.local'
 #    code <<-EOH
 #    sed -i "s/nodename/#{node.name}/g" /etc/rc.local
 #    EOH
 # end

  # Chef::Log.info("#{node["name"]} has IP address #{node["ipaddress"]}")
