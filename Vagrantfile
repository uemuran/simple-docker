# -*- mode: ruby -*-
# vi: set ft=ruby :
 
Vagrant.configure("2") do |config|
    config.vm.define "phusion" do |v| 
        v.vm.provider "docker" do |d| 
            d.build_dir = "."
            d.has_ssh = true
        end 
        v.ssh.username = "root"	
        v.ssh.private_key_path = "insecure_key"
        v.ssh.port = 22
        v.vm.provision "shell", inline: "echo hello"
    end 
end
