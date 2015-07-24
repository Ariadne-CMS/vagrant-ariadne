# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

# Define Number of RAM for each node
	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--memory", 512]
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	end
	config.vm.box = "mjrider/debian-7-puppet"
	config.vm.network "forwarded_port", guest: 80, host: 8080

	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "manifests"
		puppet.module_path = "modules"
		puppet.manifest_file = "site.pp"
		puppet.options = '--verbose --hiera_config=/etc/hiera.yaml'
	end

	config.vm.host_name = "ariadne-dev.local"
	config.ssh.forward_agent = true
end
