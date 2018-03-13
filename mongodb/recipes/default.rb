#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Cookbook:: mongodb
# Recipe:: default
#

include_recipe "mongodb::install"
include_recipe "mongodb::hostname"
# include_recipe "mongodb::test-dir"
#include_recipe "mongodb::replication"
