default[:mongodb][:gz] = "/opt/mongodb-3.4.2.tgz"
default[:mongodb][:downloadlink] = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.4.2.tgz"
default[:mongodb][:working_dir] = "/opt"
default[:mongodb][:parent_dir] = "/opt/mongodb"
default[:mongodb][:group] = "mongodb"
default[:mongodb][:user] = "mongodb"
default[:mongodb][:data_dir] = "/opt/mongodb/data"
default[:mongodb][:log_dir] = "/opt/mongodb/log"
default[:mongodb][:pid_dir] = "/opt/mongodb/pid"
default[:mongodb][:config] = "/etc/mongodb.conf"
default[:mongodb][:service] = "/etc/init.d/mongodb"
default[:mongodb][:hostnamefile] = "/etc/hostname"
# default[:mongodb][:hostname] = "mongodb-chef"
default[:mongodb][:path] = "/opt/mongodb-linux-x86_64-ubuntu1404-3.4.2/bin"
default[:mongodb][:port] = "27017"
default[:mongodb][:replset] = "mongo-data-uat"
default[:mongodb][:oplogsize] = "1024"
default[:mongodb][:smallfiles] = "true"
default[:mongodb][:replicationConfigJs] = "/tmp/replicationConfig.js"
default[:mongodb][:replication][:enabled] = "true"
default[:mongodb][:authorization][:enabled] = "true"
# default[:mongodb][:test_data_dir] = "/opt/mongodb/test_data"
# default[:mongodb][:test_log_dir] = "/opt/mongodb/test_log_dir"
# default[:mongodb][:test_pid_dir] = "/opt/mongodb/test_pid"
# # default[:mongodb] = {
#   :directory => {
#     :structure => [
#       "#{node.default[:mongodb][:test_data_dir]}",
#       "#{node.default[:mongodb][:test_log_dir]}",
#       "#{node.default[:mongodb][:test_pid_dir]}"
#   ],
# },
