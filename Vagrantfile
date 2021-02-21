# -*- mode: ruby -*-
# vi: set ft=ruby :

g_bridge = "Intel(R) I211 Gigabit Network Connection"
g_gui = false # true: display the VirtualBox GUI when booting the machine
g_mem_master = "1024"
g_mem_slave = "512"
masters = ["master0", "master1"]
slaves = ["slave0", "slave1", "slave2"]

Vagrant.configure("2") do |config|
  config.vm.synced_folder "./data", "/vagrant_data"

  # This is now in every machine
  # config.vm.provider "virtualbox" do |vb|
  #   vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
  #   vb.memory = g_mem_{master|slave}
  # end

  config.vm.provision "shell", inline: <<-SHELL
    echo "Global Provisioning goes here..."
    # https://wiki.alpinelinux.org/wiki/Docker
    apk add docker
    addgroup vagrant docker
    rc-update add docker boot
    service docker start
  SHELL

  config.vm.define "master0" do |master0|
    master0.vm.box = "generic/alpine312"
    master0.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
    master0.vm.provision "shell", inline: <<-SHELL
      echo "master0.localdomain" > /etc/hostname
    SHELL

    master0.vm.provider "virtualbox" do |vb|
      vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
      vb.memory = g_mem_master
    end
  end

  config.vm.define "master1" do |master1|
    master1.vm.box = "generic/alpine312"
    master1.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
    master1.vm.provision "shell", inline: <<-SHELL
      echo "master1.localdomain" > /etc/hostname
    SHELL

    master1.vm.provider "virtualbox" do |vb|
      vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
      vb.memory = g_mem_master
    end
  end

  config.vm.define "slave0" do |slave0|
    slave0.vm.box = "generic/alpine312"
    slave0.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
    slave0.vm.provision "shell", inline: <<-SHELL
      echo "slave0.localdomain" > /etc/hostname
    SHELL

    slave0.vm.provider "virtualbox" do |vb|
      vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
      vb.memory = g_mem_slave
    end
  end

  config.vm.define "slave1" do |slave1|
    slave1.vm.box = "generic/alpine312"
    slave1.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
    slave1.vm.provision "shell", inline: <<-SHELL
      echo "slave1.localdomain" > /etc/hostname
    SHELL

    slave1.vm.provider "virtualbox" do |vb|
      vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
      vb.memory = g_mem_slave
    end
  end

  config.vm.define "slave2" do |slave2|
    slave2.vm.box = "generic/alpine312"
    slave2.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
    slave2.vm.provision "shell", inline: <<-SHELL
      echo "slave2.localdomain" > /etc/hostname
    SHELL

    slave2.vm.provider "virtualbox" do |vb|
      vb.gui = g_gui # Display the VirtualBox GUI when booting the machine
      vb.memory = g_mem_slave
    end
  end

end
