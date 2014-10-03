# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

BOX_MEM = "1024"
BOX_NAME =  "CentOS-6.5-x86_64-v20140311.box"
BOX_URI = "https://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140311.box"
HOSTS_NO_PROXY = "localhost,127.0.0.0/8,beakeragent01,beakeragent02,beakeragent03,beakermaster"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
	config.vm.box_download_insecure = true
	config.proxy.http = ""
	config.proxy.https = ""
	config.proxy.no_proxy = HOSTS_NO_PROXY
  
  config.vm.define :beakeragent01 do |beakeragent01_config|
    beakeragent01_config.vm.network :private_network, ip: "10.1.172.11"    
    beakeragent01_config.vm.hostname = "beakeragent01.local"
    beakeragent01_config.vm.provider "virtualbox" do |v|
      v.name = "beakeragent01"
      v.gui = "true"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	  end  
  end
  config.vm.define :beakeragent02 do |beakeragent02_config|
    beakeragent02_config.vm.network :private_network, ip: "10.1.172.12"    
    beakeragent02_config.vm.hostname = "beakeragent02.local"
    beakeragent02_config.vm.provider "virtualbox" do |v|
      v.name = "beakeragent02"
      v.gui = "true"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	  end  
  end
  config.vm.define :beakeragent03 do |beakeragent03_config|
    beakeragent03_config.vm.network :private_network, ip: "10.1.172.13"    
    beakeragent03_config.vm.hostname = "beakeragent03.local"
    beakeragent03_config.vm.provider "virtualbox" do |v|
      v.name = "beakeragent03"
      v.gui = "true"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	  end  
  end
 
  config.vm.define :beakermaster do |beakermaster_config|
    beakermaster_config.vm.network :private_network, ip: "10.1.172.10"
    beakermaster_config.vm.network "forwarded_port", guest: 8140, host: 8140
    beakermaster_config.vm.network "forwarded_port", guest: 443, host: 4431
    beakermaster_config.vm.hostname = "beakermaster.local"
    beakermaster_config.vm.provider "virtualbox" do |v, override|
      v.name = "beakermaster"
      v.gui = "true"
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	  override.proxy.enabled = false
	  end  
  	beakermaster_config.vm.provision "shell",
		inline: "cp -af /vagrant/puppet_config/manifests/site.pp /etc/puppet/manifests/site.pp;
		cp -raf /vagrant/puppet_config/modules/beaker /etc/puppet/modules/;
		puppet module install puppetlabs-vcsrepo; chkconfig puppetmaster on;"

  end

  config.vm.provision :hosts do |provisioner|
        provisioner.add_host '10.1.172.10', ['beakermaster.local', 'puppet', 'beakermaster']
        provisioner.add_host '10.1.172.11', ['beakeragent01.local', 'beakeragent01']
        provisioner.add_host '10.1.172.12', ['beakeragent02.local', 'beakeragent02']
        provisioner.add_host '10.1.172.13', ['beakeragent03.local', 'beakeragent03']
  end
    
  config.vm.provision "shell",
	inline: "cp -af /vagrant/puppet_config/puppet.conf /etc/puppet/"
	
end