
require_recipe "nodejs"

execute "initialize_project" do
    cwd '/vagrant'
    command <<-EOH
        npm install
    EOH
end
