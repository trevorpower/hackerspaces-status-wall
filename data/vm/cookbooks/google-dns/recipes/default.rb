
# OpenDNS has trouble as of April 23rd, see http://stackoverflow.com/q/23231788
# TODO: this is not the way how to do it correctly, and the resolv config files
#       are all overridden: http://askubuntu.com/q/157154
execute "sudo echo \"nameserver 8.8.8.8\" > /etc/resolvconf/resolv.conf.d/original" do
end
