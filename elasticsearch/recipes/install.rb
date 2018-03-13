#
# Cookbook:: elasticsearch-chef
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

bash "apt-get-update" do
  not_if { File.exists?("/tmp/update.txt")}
  code <<-EOH
  sudo apt-get update
  touch /tmp/update.txt
  EOH
end

hostname  "#{node.name}"



group "#{node.default[:elasticsearch][:group]}"

user "#{node.default[:elasticsearch][:user]}" do
  comment "elasticsearch user"
  system true
  group "#{node.default[:elasticsearch][:group]}"
  shell '/bin/false'
end

%W[ #{node.default[:elasticsearch][:parent_dir]} #{node.default[:elasticsearch][:path][:data]} #{node.default[:elasticsearch][:path][:log]} ].each do |dir|
  directory dir do
  # recursive true
  owner "#{node.default[:elasticsearch][:user]}"
  group "#{node.default[:elasticsearch][:group]}"
  mode '0755'
  action :create
  end
end

%w{ vim htop curl wget zip unzip telnet tar screen}.each do |pkg|
  package pkg do
  action :install
#  notifies :run, resources(:execute => "apt-get-update"), :before
  end
end

remote_file "#{node.default[:elasticsearch][:deb][:path]}" do
  source "#{node.default[:elasticsearch][:deb][:url]}"
  action :create_if_missing
end

execute "installing elasticsearch" do
  command "dpkg -i #{node.default[:elasticsearch][:deb][:path]}"
  not_if "dpkg -l | grep -i elasticsearch"
end

template "#{node.default[:elasticsearch][:service]}" do
source 'elasticsearch.service.erb'
owner "root"
group "root"
mode '0755'
end

service "elasticsearch" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end


template "#{node.default[:elasticsearch][:jvmconfig]}" do
source "jvm.options.erb"
owner "root"
group "elasticsearch"
mode "660"
notifies :restart, "service[elasticsearch]"
end

template "#{node.default[:elasticsearch][:config]}" do
source "elasticsearch.yml.erb"
owner "root"
group "elasticsearch"
notifies :restart, "service[elasticsearch]"
end

remote_file "#{node.default[:elasticsearch][:cerebro][:ziplocation]}" do
  source "#{node.default[:elasticsearch][:cerebro][:zip]}"
  action :create_if_missing
end

execute "extract cerebro zip" do
  command "tar -xvf #{node.default[:elasticsearch][:cerebro][:ziplocation]}"
  cwd "#{node.default[:elasticsearch][:cerebro][:working_dir]}"
  not_if { File.exists?("/opt/cerebro-0.6.5") }
end
#
execute "run cerebro" do
  not_if { File.exists?("/opt/cerebro-0.6.5/RUNNING_PID") }
  command "nohup /opt/cerebro-0.6.5/bin/cerebro -Dhttp.port=1234 -Dhttp.address=0.0.0.0 &"
end

execute "install s3 plugin" do
  not_if { File.exists?("/usr/share/elasticsearch/plugins/repository-s3/repository-s3-5.2.2.jar")}
  command "sudo update-ca-certificates -f && /usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3"
  notifies :restart, "service[elasticsearch]"
end

execute 'reload initctl' do
  command 'sudo initctl reload-configuration'
end

service 'elasticsearch' do
  supports :status => true, :restart => true
  action [:enable, :start]
end
