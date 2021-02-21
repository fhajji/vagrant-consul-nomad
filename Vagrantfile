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
    # echo "Global Provisioning goes here..."
    apk update && apk upgrade
    # https://wiki.alpinelinux.org/wiki/Docker
    apk add docker
    addgroup vagrant docker
    rc-update add docker boot
    service docker start
  SHELL

  masters.each do |machine|
    config.vm.define machine do |node|
      node.vm.box = "generic/alpine312"
      node.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
      node.vm.provision "shell", inline: <<-SHELL
        echo "#{machine}" > /etc/hostname
      SHELL

      node.vm.provider "virtualbox" do |vb|
        vb.gui = g_gui
        vb.memory = g_mem_master
      end
    end
  end

  slaves.each do |machine|
    config.vm.define machine do |node|
      node.vm.box = "generic/alpine312"
      node.vm.network "public_network", bridge: g_bridge, type: :dhcp, auto_config: true
      node.vm.provision "shell", inline: <<-SHELL
        echo "#{machine}" > /etc/hostname
      SHELL

      node.vm.provider "virtualbox" do |vb|
        vb.gui = g_gui
        vb.memory = g_mem_slave
      end
    end
  end
end
