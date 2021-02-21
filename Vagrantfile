# -*- mode: ruby -*-
# vi: set ft=ruby :

g_bridge = "Intel(R) I211 Gigabit Network Connection"

servers = [
  {
    :type => "master",
    :hostname => "master0",
    :ip => "192.168.76.150",
    :box => "generic/alpine312",
    :ram => 1024,
    :cpus => 4,
    :gui => false
  },
  {
    :type => "master",
    :hostname => "master1",
    :ip => "192.168.76.151",
    :box => "generic/alpine312",
    :ram => 1024,
    :cpus => 4,
    :gui => false
  },
  {
    :type => "slave",
    :hostname => "slave0",
    :ip => "192.168.76.160",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false
  },
  {
    :type => "slave",
    :hostname => "slave1",
    :ip => "192.168.76.161",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false
  },
  {
    :type => "slave",
    :hostname => "slave2",
    :ip => "192.168.76.162",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false
  }
]

Vagrant.configure("2") do |config|
  # A common shared folder
  # XXX todo: all a per-machine shared folder too
  config.vm.synced_folder "./data", "/vagrant_data"

  config.vm.provision "shell", inline: <<-SHELL
    # echo "Global Provisioning goes here..."
    apk update && apk upgrade
    apk upgrade virtulbox-guest-additions --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
    # https://wiki.alpinelinux.org/wiki/Docker
    apk add docker
    addgroup vagrant docker
    rc-update add docker boot
    service docker start
    # https://stackoverflow.com/questions/63080980/how-to-install-terraform-0-12-in-an-alpine-container-with-apk
    apk add consul vault nomad terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
  SHELL

  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.network "public_network", bridge: g_bridge, ip: machine[:ip], auto_config: true
      node.vm.provision "shell", inline: <<-SHELL
        echo "#{machine[:hostname]}" > /etc/hostname
      SHELL

      node.vm.provider "virtualbox" do |vb|
        vb.gui = machine[:gui]
        vb.memory = machine[:ram]
        vb.cpus = machine[:cpus]
      end
    end
  end
end
