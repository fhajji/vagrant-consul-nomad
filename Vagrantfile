# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder "./data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true # Display the VirtualBox GUI when booting the machine
    vb.memory = "512"
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "Global Provisioning goes here..."
  SHELL

  config.vm.define "master0" do |master0|
    master0.vm.box = "generic/alpine312"
    master0.vm.network "public_network", bridge: "Intel(R) I211 Gigabit Network Connection", type: :dhcp, auto_config: true
    master0.vm.provision "shell", inline: <<-SHELL
      echo "master0.localdomain" > /etc/hostname
    SHELL
  end

  config.vm.define "master1" do |master1|
    master1.vm.box = "generic/alpine312"
    master1.vm.network "public_network", bridge: "Intel(R) I211 Gigabit Network Connection", type: :dhcp, auto_config: true
    master1.vm.provision "shell", inline: <<-SHELL
      echo "master1.localdomain" > /etc/hostname
    SHELL
  end

  config.vm.define "slave0" do |slave0|
    slave0.vm.box = "generic/alpine312"
    slave0.vm.network "public_network", bridge: "Intel(R) I211 Gigabit Network Connection", type: :dhcp, auto_config: true
    slave0.vm.provision "shell", inline: <<-SHELL
      echo "slave0.localdomain" > /etc/hostname
    SHELL
  end

  config.vm.define "slave1" do |slave1|
    slave1.vm.box = "generic/alpine312"
    slave1.vm.network "public_network", bridge: "Intel(R) I211 Gigabit Network Connection", type: :dhcp, auto_config: true
    slave1.vm.provision "shell", inline: <<-SHELL
      echo "slave1.localdomain" > /etc/hostname
    SHELL
  end

  config.vm.define "slave2" do |slave2|
    slave2.vm.box = "generic/alpine312"
    slave2.vm.network "public_network", bridge: "Intel(R) I211 Gigabit Network Connection", type: :dhcp, auto_config: true
    slave2.vm.provision "shell", inline: <<-SHELL
      echo "slave2.localdomain" > /etc/hostname
    SHELL
  end

end
