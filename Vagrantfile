# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

SERVER_IP               = "192.168.33.10"
SERVER_CPUS             = "1"
SERVER_MEMORY           = "512"

PHP_VERSION             = "5.5"   # 5.5

MYSQL_VERSION           = "5.5"   # 5.5
MYSQL_ROOT_PASSWORD     = "root"

SHELL_FOLDER            = "/vagrant"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: SERVER_IP

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder ".", "/vagrant",
  #          id: "core",
  #          :nfs => true,
  #          :mount_options => ['nolock,vers=3,udp,noatime']

  # Synced Folder
  # --------------------
  config.vm.synced_folder ".", "/vagrant/", :mount_options => [ "dmode=775", "fmode=644" ], :owner => 'www-data', :group => 'www-data'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    vb.name = "Agentbox"
  
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", SERVER_MEMORY]

    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", SERVER_CPUS]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

    # Prevent VMs running on Ubuntu to lose internet connection
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  # View the documentation for the provider you're using for more
  # information on available options.

  # Provisioning Base Packages
  config.vm.provision "shell", path: ".#{SHELL_FOLDER}/base.sh"

  # Provision LAMP
  config.vm.provision "shell", path: ".#{SHELL_FOLDER}/lamp.sh",
            args: [PHP_VERSION, MYSQL_VERSION, MYSQL_ROOT_PASSWORD]

  # Provision Composer
  config.vm.provision "shell", path: ".#{SHELL_FOLDER}/composer.sh", privileged: false

  # Provision vhost
  config.vm.provision "shell", path: ".#{SHELL_FOLDER}/sites.sh"

end
