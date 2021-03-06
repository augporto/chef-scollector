#
# Cookbook Name:: scollector
# Recipe:: install
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'chef-sugar'

node.default['scollector']['arch'] = _64_bit? ? 'amd64' : '386'

case node['scollector']['install_style']
when 'source'
  node.default['go']['packages']           	 = ['bosun.org/cmd/scollector']
  node.default['scollector']['bin_path'] 	   = "#{node['go']['gobin']}/scollector"
  include_recipe 'golang::packages'
else
  binary = "scollector-#{node['os']}-#{node['scollector']['arch']}"
  remote_file 'scollector_binary' do
    path node['scollector']['bin_path']
    source [
      node['scollector']['release_url'],
      node['scollector']['version'],
      binary
    ].join('/')
    owner 'root'
    mode '0755'
    action :create
  end
end
