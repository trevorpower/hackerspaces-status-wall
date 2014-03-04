Vagrant.configure("2") do |config|
      config.vm.box = "precise64"
      config.vm.box_url = "http://files.vagrantup.com/precise64.box"

      # comment out this line and change the interface name
      # if you want to make the box world-accessible
      #config.vm.network "public_network", :bridge => 'enp4s0'

      # http://<domain>:8090
      config.vm.network :forwarded_port, guest: 80, host: 8090

      # https://<domain>:8091
      #config.vm.network :forwarded_port, guest: 443, host: 8091

      #config.vm.network :forwarded_port, guest: 3306, host: 3306

      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 512]
        #vb.gui = true
      end
      config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :owner => "vagrant", :group => "vagrant"
      config.vm.provision :chef_solo do |chef|
         chef.cookbooks_path = "data/vm/cookbooks"
         chef.add_recipe("vagrant_main")
         chef.log_level = :debug
      end
end
