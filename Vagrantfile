# _*_ mode: ruby _*_
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    
    # Master VM configuration
    config.vm.define "master" do |master|
        master.vm.box = "ubuntu/focal64"
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: "192.168.50.20"
        master.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
        end
        master.vm.provision "shell", inline: <<-SHELL
            sudo apt update
            sudo apt upgrade -y
        SHELL
    end

    # Slave VM configuration
    config.vm.define "slave" do |slave|
        slave.vm.box = "ubuntu/focal64"
        slave.vm.hostname = "slave"
        slave.vm.network "private_network", ip: "192.168.50.21"
        slave.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
        end
        slave.vm.provision "shell", inline: <<-SCRIPT
            sudo apt update
            sudo apt upgrade -y
        SCRIPT
    end
end