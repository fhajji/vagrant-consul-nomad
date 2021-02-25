# -*- mode: ruby -*-
# vi: set ft=ruby :

g_bridge = "Intel(R) I211 Gigabit Network Connection"

servers = [
  {
    :type => "master",
    :hostname => "master0",
    :ip => "192.168.76.150",
    :ip_internal => "10.0.0.150",
    :box => "generic/alpine312",
    :ram => 1024,
    :cpus => 4,
    :gui => false,
    :shared_folder_local => "./data/master0",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => <<-SHELL
    apk add nginx
    mkdir -p /run/nginx
    chown vagrant:vagrant /run/nginx
    echo "If needed, start nginx with /etc/hashicorp.d/nginx.d/"
    SHELL
  },
  {
    :type => "master",
    :hostname => "master1",
    :ip => "192.168.76.151",
    :ip_internal => "10.0.0.151",
    :box => "generic/alpine312",
    :ram => 1024,
    :cpus => 4,
    :gui => false,
    :shared_folder_local => "./data/master1",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => ""
  },
  {
    :type => "master",
    :hostname => "master2",
    :ip => "192.168.76.152",
    :ip_internal => "10.0.0.152",
    :box => "generic/alpine312",
    :ram => 1024,
    :cpus => 4,
    :gui => false,
    :shared_folder_local => "./data/master2",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => ""
  },
  {
    :type => "slave",
    :hostname => "slave0",
    :ip => "192.168.76.160",
    :ip_internal => "10.0.0.160",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false,
    :shared_folder_local => "./data/slave0",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => "",
  },
  {
    :type => "slave",
    :hostname => "slave1",
    :ip => "192.168.76.161",
    :ip_internal => "10.0.0.161",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false,
    :shared_folder_local => "./data/slave1",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => ""
  },
  {
    :type => "slave",
    :hostname => "slave2",
    :ip => "192.168.76.162",
    :ip_internal => "10.0.0.162",
    :box => "generic/alpine312",
    :ram => 512,
    :cpus => 2,
    :gui => false,
    :shared_folder_local => "./data/slave2",
    :shared_folder_remote => "/etc/hashicorp.d",
    :provision => ""
  }
]

Vagrant.configure("2") do |config|
  # A common shared folder
  # XXX todo: all a per-machine shared folder too
  config.vm.synced_folder "./data/common", "/vagrant_data"

  config.vm.provision "shell", inline: <<-SHELL
    # echo "Global Provisioning goes here..."
    # 0. Set up networking manually, part 1 (auto_config must be false!)
    echo "auto lo" > /etc/network/interfaces
    echo "iface lo inet loopback" >> /etc/network/interfaces
    echo "" >> /etc/network/interfaces
    # 1. General update
    apk update && apk upgrade
    apk upgrade virtulbox-guest-additions --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
    apk add tmux
    # 2. https://wiki.alpinelinux.org/wiki/Docker
    apk add docker
    addgroup vagrant docker
    rc-update add docker boot
    service docker start
    # 3. https://stackoverflow.com/questions/63080980/how-to-install-terraform-0-12-in-an-alpine-container-with-apk
    apk add consul vault nomad terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
    addgroup vagrant consul
    chown --recursive vagrant:vagrant /var/consul
    apk add jq
    # 4. Add CNI plugins
    # https://www.nomadproject.io/docs/integrations/consul-connect
    # https://v0-9-0.cni.dev/
    # https://github.com/containernetworking/cni
    curl -s -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v0.9.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v0.9.0.tgz
    mkdir -p /opt/cni/bin
    tar -C /opt/cni/bin -xzf cni-plugins.tgz
    echo "net.bridge.bridge-nf-call-arptables = 1" > /etc/sysctl.d/cni.conf
    echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/cni.conf
    echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/cni.conf
    apk add ip6tables
    rm -f cni-plugins.tgz
  SHELL
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.network "public_network", bridge: g_bridge, ip: machine[:ip], type: "static", auto_config: false
      node.vm.network "private_network", ip: machine[:ip_internal], type: "static", auto_config: false
      node.vm.provision "shell", inline: <<-SHELL
        # Set up networking manually, part 2:
        echo "auto eth0" >> /etc/network/interfaces
        echo "iface eth0 inet dhcp" >> /etc/network/interfaces
        echo "    hostname #{machine[:hostname]}" >> /etc/network/interfaces
        echo "" >> /etc/network/interfaces
        echo "auto eth1" >> /etc/network/interfaces
        echo "iface eth1 inet static" >> /etc/network/interfaces
        echo "    address #{machine[:ip]}" >> /etc/network/interfaces
        echo "    netmask 255.255.255.0" >> /etc/network/interfaces
        echo "" >> /etc/network/interfaces
        echo "auto eth2" >> /etc/network/interfaces
        echo "iface eth2 inet static" >> /etc/network/interfaces
        echo "    address #{machine[:ip_internal]}" >> /etc/network/interfaces
        echo "    netmask 255.255.255.0" >> /etc/network/interfaces
        ifup eth1
        ifup eth2
        # Fix hostname
        echo "#{machine[:hostname]}" > /etc/hostname
        #{machine[:provision]}
      SHELL
      
      node.vm.synced_folder machine[:shared_folder_local], machine[:shared_folder_remote]

      node.vm.provider "virtualbox" do |vb|
        vb.gui = machine[:gui]
        vb.memory = machine[:ram]
        vb.cpus = machine[:cpus]
      end
    end
  end
end
