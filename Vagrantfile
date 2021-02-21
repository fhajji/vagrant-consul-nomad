# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder "./data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true # Display the VirtualBox GUI when booting the machine
    vb.memory = "512"
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "Provisioning goes here..."
  SHELL

  config.vm.define "master0" do |master0|
    master0.vm.box = "generic/alpine312"
    master0.vm.network "private_network", type: :dhcp, auto_config: false
  end

  config.vm.define "master1" do |master1|
    master1.vm.box = "generic/alpine312"
    master1.vm.network "private_network", type: :dhcp, auto_config: false
  end

  config.vm.define "slave0" do |slave0|
    slave0.vm.box = "generic/alpine312"
    slave0.vm.network "private_network", type: :dhcp, auto_config: false
  end

  config.vm.define "slave1" do |slave1|
    slave1.vm.box = "generic/alpine312"
    slave1.vm.network "private_network", type: :dhcp, auto_config: false
  end

  config.vm.define "slave2" do |slave2|
    slave2.vm.box = "generic/alpine312"
    slave2.vm.network "private_network", type: :dhcp, auto_config: false
  end

end
