
execute "install foreman" do
    command "mkdir -p /data/db"
end

package "mongodb" do
  action :install
end
