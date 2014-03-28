Vagrant.configure("2") do |config|
  config.vm.box      = 'precise32'
  config.vm.box_url  = 'http://files.vagrantup.com/precise32.box'
  config.vm.synced_folder "vagrant", "/vagrant"
  config.vm.synced_folder ".", "/project"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 512]
  end
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network :forwarded_port, guest: 3000, host: 3013
  config.vm.provision :puppet do |puppet|
    puppet.module_path = "vagrant/modules"
    puppet.manifests_path = "vagrant/manifests"
    puppet.manifest_file  = "webdev.pp"
  end
end
