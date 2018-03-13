#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Cookbook:: mongodb
# Recipe:: replication
#



dbnodes = search(:node, "role:mongodb")
dbnodes.each do |node|
  hostsfile_entry "#{node['ipaddress']}" do
  hostname  "#{node.name}"
  comment   'Update by Chef'
  action    :create
  unique    true
  end
end
  # bash 'update hosts file for replication' do
  # not_if { }
  # code <<-EOH
  # echo "#{node["ipaddress"]}  #{node.name}" >> /etc/hosts
  # EOH

template "#{node.default[:mongodb][:replicationConfigJs]}" do
  not_if { File.exists?("#{node.default[:mongodb][:replicationConfigJs]}") }
source 'replicationConfig.js.erb'
owner "mongodb"
group "nogroup"
mode '0755'
action :create_if_missing
end

dbnodes = search(:node, "role:mongodb")
dbnodes.each do |node|
  bash 'update mongodb node names in replicationConfig.js file' do
  only_if "grep -i node #{node.default[:mongodb][:replicationConfigJs]}"
  code <<-EOH
  sed -i "0,/node/ s/node/#{node.name}/" "#{node.default[:mongodb][:replicationConfigJs]}"
  EOH
 end
end

# rs.initiate(config);

  # Chef::Log.info("#{node["name"]} has IP address #{node["ipaddress"]}")
