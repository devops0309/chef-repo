#
# Cookbook:: elasticsearch-chef
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
# include_recipe "elasticsearch-chef::installjava"
include_recipe 'java'
include_recipe "elasticsearch::install"
