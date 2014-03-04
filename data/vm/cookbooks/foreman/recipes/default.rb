
execute "install foreman" do
    cwd '/tmp'
    command <<-EOH
        echo "deb http://deb.theforeman.org/ precise 1.5" >> /etc/apt/sources.list
        echo "deb http://deb.theforeman.org/ plugins 1.5" >> /etc/apt/sources.list
        wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
        aptitude update
    EOH
    not_if "grep -o theforeman /etc/apt/sources.list /etc/apt/sources.list.d/*"
end

package "foreman" do
  action :install
end

package "foreman-cli" do
  action :install
end

package "foreman-console" do
  action :install
end

package "foreman-gce" do
  action :install
end

package "ruby-hammer-cli-foreman" do
  action :install
end

package "ruby-hammer-cli" do
  action :install
end
