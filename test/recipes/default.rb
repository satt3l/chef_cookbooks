#
# Cookbook Name:: test
# Recipe:: default
#
# Copyright (c) 2018 The Authors, All Rights Reserved.

package 'python' do
	# version node['test']['python_version']
	action :install
end

package 'python-pip' do
	# version node['test']['pip_version']
	action :install
end

directory node['test']['app_path'] do
  owner node['test']['app_user']
  group node['test']['app_user_group']
  recursive true
  mode '0755'
  action :create
end

git "#{node['test']['app_path_to_release']}" do 
	repository node['test']['repository']
	action :sync
end

# run app server
# run curl command
bash 'install_pip_modules_and_start_app_server' do
  cwd "#{node['test']['app_path']}/app1"
  code <<-EOH
    pip install -r #{node['test']['pip_reqs']}
    python manage.py runserver #{node['test']['app_listen']} &
    sleep 5
    curl -I 127.0.0.1:#{node['test']['app_listen_port']}
  EOH
end