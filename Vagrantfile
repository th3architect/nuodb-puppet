# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "CentOS6.5-puppet"
  config.vm.box_url = "//puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"
  config.librarian_puppet.puppetfile_dir = "vagrant"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "vagrant"
    puppet.manifest_file  = "site.pp"
    puppet.module_path = [".", "vagrant/modules"]
    puppet.options = "--verbose --debug"
  end

end
