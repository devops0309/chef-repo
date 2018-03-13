#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Cookbook:: mongodb
# Recipe:: install
#
# Copyright:: 2017, The Authors, All Rights Reserved.
# bash 'installing awscli' do
#   not_if 'which aws'
#   code <<-EOH
#   sudo apt-get update -y
#   sudo apt-get install python-pip -y
#   sudo pip install awscli
#   EOH
# end

bash "apt-get-update" do
  not_if { File.exists?("/tmp/update.txt")}
  code <<-EOH
  sudo apt-get update
  touch /tmp/update.txt
  EOH
end

%w{ vim curl wget htop zip unzip telnet tar screen mongodb-clients}.each do |pkg|
  package pkg do
  action :install
#  notifies :run, resources(:execute => "apt-get-update"), :before
  end
end


remote_file "#{node.default[:mongodb][:gz]}" do
  source "#{node.default[:mongodb][:downloadlink]}"
  action :create_if_missing
end

execute "extract_some_tar" do
  command "tar xzvf #{node.default[:mongodb][:gz]}"
  cwd "#{node.default[:mongodb][:working_dir]}"
  not_if { File.exists?("/opt/mongodb-linux-x86_64-ubuntu1404-3.4.2") }
end


group "#{node.default[:mongodb][:group]}"

user "#{node.default[:mongodb][:user]}" do
  comment "mongodb user"
  system true
  group "#{node.default[:mongodb][:group]}"
  shell '/bin/false'
end



#  directory "/opt/mongodb" do
#     owner "#{node.default[:mongodb][:user]}"
#     group "#{node.default[:mongodb][:group]}"
#     mode '0755'
#     action :create
#     recursive true
# end
#
#  directory "#{node.default[:mongodb][:data_dir]}" do
#     owner "#{node.default[:mongodb][:user]}"
#     group "#{node.default[:mongodb][:group]}"
#     mode '0755'
#     action :create
#     recursive true
# end
#
#  directory "#{node.default[:mongodb][:pid_dir]}" do
#     owner "#{node.default[:mongodb][:user]}"
#     group "#{node.default[:mongodb][:group]}"
#     mode '0755'
#     action :create
#     recursive true
# end
#
#  directory "#{node.default[:mongodb][:log_dir]}" do
#     owner "#{node.default[:mongodb][:user]}"
#     group "#{node.default[:mongodb][:group]}"
#     mode '0755'
#     action :create
#     recursive true
# end

%W[ #{node.default[:mongodb][:parent_dir]} #{node.default[:mongodb][:data_dir]} #{node.default[:mongodb][:pid_dir]} #{node.default[:mongodb][:log_dir]} ].each do |dir|
  directory dir do
  # recursive true
  owner "#{node.default[:mongodb][:user]}"
  group "#{node.default[:mongodb][:group]}"
  mode '0755'
  action :create
  end
end

template "#{node.default[:mongodb][:service]}" do
source 'mongodb.service.erb'
owner "root"
group "root"
mode '0755'
end

service "mongodb" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end


template "#{node.default[:mongodb][:config]}" do
source "mongodb.conf.erb"
owner "#{node.default[:mongodb][:user]}"
group "#{node.default[:mongodb][:group]}"
notifies :restart, "service[mongodb]"
end
execute 'reload initctl' do
  command 'sudo initctl reload-configuration'
end

service 'mongodb' do
  supports :status => true, :restart => true
  action [:enable, :start]
end
#



 template "/tmp/enableMongoAuthorizationGuide" do
  only_if { node[:mongodb][:authorization][:enabled] == 'true' }
 source 'mongodbAuthorization.erb'
 owner "root"
 group "root"
 mode '0755'
 end



# execute "update hostname" do
# command "echo #{node.default[:mongodb][:node1]} > #{node.default[:mongodb][:hostnamefile]}"
# end
#
# bash "fetch infra details and host entry" do
#   not_if 'grep -i mongo /etc/hosts'
#   cwd "/opt"
#   code <<-EOH
#   #wget https://s3.ap-south-1.amazonaws.com/test-qa/replicationInfo.txt
#   wget #{node[:mongodb][:replicationInfoFile]} -O #{node[:mongodb][:replicationInfoFileOnDisk]}
#   grep -i mongo #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: "-f5-6" | sed 's/:/ /' >> /etc/hosts
#   echo "127.0.0.1 `grep -i #{node['ipaddress']} #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: -f6`" >> /etc/hosts
#   EOH
# end
#
# bash 'set hostname' do
#   cr 'grep -i mongo /etc/hostname'
#   cwd "/opt"
#   code <<-EOH
#   grep -i #{node['ipaddress']} #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: -f6 > /etc/hostname
#   hostname `cat /etc/hostname`
#   EOH
# end



# template "/opt/replicationConfig.js" do
# source "replicationConfig.js.erb"
# owner "#{node.default[:mongodb][:user]}"
# group "#{node.default[:mongodb][:group]}"
# end
#
# bash "replacing node dns in replicationConfig.js" do
#   cr 'grep  -i mongo /opt/replicationConfig.js'
#   cwd "/opt"
#   code <<-EOH
#   node1=`grep -i mongo1 #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: -f6`
#   node2=`grep -i mongo2 #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: -f6`
#   node3=`grep -i mongo3 #{node[:mongodb][:replicationInfoFileOnDisk]} | cut -d: -f6`
#   replset=#{node.default[:mongodb][:replset]}
#   sed -i "s/REPLSET/${replset}/" /opt/replicationConfig.js
#   sed -i "s/NODE1/${node1}/" /opt/replicationConfig.js
#   sed -i "s/NODE2/${node2}/" /opt/replicationConfig.js
#   sed -i "s/NODE3/${node3}/" /opt/replicationConfig.js
#   EOH
# end
#
# bash "gathering latest mongodump from s3"  do
#   cwd "/opt"
#   code <<-EOH
#   aws s3 cp s3://#{node[:mongodb][:bucket]}/#{node[:mongodb][:latestDumpFile]} . --region ap-south-1
#   dumpFile=`cat #{node[:mongodb][:latestDumpFile]}`
#   aws s3 cp s3://#{node[:mongodb][:bucket]}/${dumpFile} . --region ap-south-1
#   mkdir dump
#   mv ${dumpFile} dump/
#   tar -xvzf dump/${dumpFile}
#   EOH
# end
#
#initializing replset mongo --port 27017 </opt/replicaSetConfigInit.js
#sourcing db dump mongorestore --db notification_load /opt/dump/notification_qa
#sourcing db dump mongorestore --db test_load /opt/dump/test_qa
