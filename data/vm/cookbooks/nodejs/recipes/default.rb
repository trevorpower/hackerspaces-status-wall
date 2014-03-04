
require_recipe "python-software-properties"

execute "add_ppa_nodejs" do
    command "sudo add-apt-repository ppa:chris-lea/node.js && sudo apt-get update"
    not_if "grep -o chris-lea/node.js /etc/apt/sources.list /etc/apt/sources.list.d/*"
end

package "nodejs" do
  action :install
end