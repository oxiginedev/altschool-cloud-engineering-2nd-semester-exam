# _*_ mode: ruby _*_
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define "master" do |master|
        master.vm.box = "ubuntu/focal64"
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: "192.168.53.5"
        master.vm.network "forwarded_port", guest: 80, host:5000
    end

    config.vm.define "slave" do |slave|
        slave.vm.box = "ubuntu/focal64"
        slave.vm.hostname = "slave"
        slave.vm.network "private_network", ip: "192.168.53.6"
        slave.vm.network "forwarded_port", guest: 80, host:8080
    end

    config.ssh.insert_key = false
end