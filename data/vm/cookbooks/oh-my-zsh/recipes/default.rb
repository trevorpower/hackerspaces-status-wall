
require_recipe "zsh"
require_recipe "git"
require_recipe "users"

execute "download oh-my-zsh" do
    command "rm -rf /tmp/.oh-my-zsh && git clone https://github.com/robbyrussell/oh-my-zsh.git /tmp/.oh-my-zsh"
end

# http://docs.opscode.com/resource_execute.html
['/root', '/home/vagrant'].each do |dir|
  execute "install oh-my-zsh" do
    cwd "#{dir}"
    command "rm -rf .oh-my-zsh; cp -r /tmp/.oh-my-zsh . && cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc"
  end
end

user "root" do
  shell "/usr/bin/zsh"
end

user "vagrant" do
  shell "/usr/bin/zsh"
end