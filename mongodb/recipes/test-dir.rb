#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
# Cookbook:: mongodb
# Recipe:: hostname
#


# directory "#{node.default[:mongodb][:data_dir]}" do
#    owner "#{node.default[:mongodb][:user]}"
#    group "#{node.default[:mongodb][:group]}"
#    mode '0755'
#    action :create
#    recursive true
# end

#  %w[ node.default[:mongodb][:test_data_dir] node.default[:mongodb][:test_pid_dir] #{node.default[:mongodb][:test_log_dir]].each do |dir|
#   directory dir do
#   action :create
#   recursive true
#   end
# end

# node.default[:mongodb][:directory][:structure].each do |i|
#   directory i do
#     action :create
#   end
# end
