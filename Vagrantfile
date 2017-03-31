# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

Vagrant.configure(2) do |config|
    # Box (operation system)
    config.vm.box = "ubuntu/trusty64"

    # Sync ansible folder
    config.vm.synced_folder "ansible", "/etc/ansible", mount_options: ["fmode=666"]

    # Load config file
    # We can use more machines
    if File.exist?('config.yml') then
        configContent = YAML.load_file('config.yml')
    end

    # Define first machine with name 'devcloud'
    config.vm.define "devcloud", primary: true do |machine|
        # Default config
        virtualbox_memory = 1024
        virtualbox_cpus = 2

        # Use configuration of 'devcloud' machime from confing.yml if exist
        if defined? configContent and configContent.has_key?('devcloud') then
            machineConfig = configContent['devcloud']

            # Get memory
            if machineConfig.has_key?('virtualbox_memory') then
                virtualbox_memory = machineConfig['virtualbox_memory']
            end

            # Get number of cpus
            if machineConfig.has_key?('virtualbox_cpus') then
                virtualbox_cpus = machineConfig['virtualbox_cpus']
            end

            # Get chare type
            if machineConfig.has_key?('virtualbox_share_type') then
                virtualbox_share_type = machineConfig['virtualbox_share_type']
            end

            # Get sync fikders
            if machineConfig.has_key?('share') then
                machineConfig['share'].each do |name, options|

                    if options.has_key?('type') then
                        machine.vm.synced_folder options['path'], "/mnt/shares/" + name, type: options['type']
                    else
                        machine.vm.synced_folder options['path'], "/mnt/shares/" + name
                    end
                end
            end
        end

        # Set name, network and other confing of machine
        machine.vm.hostname = "demo-devcloud"
        machine.vm.network "private_network", ip: '192.168.33.20'
        machine.vm.provider "virtualbox" do |vb|
            vb.name = "demo-devcloud"
            vb.memory = virtualbox_memory
            vb.cpus = virtualbox_cpus
        end

        # Set machine provision (Ansible)
        machine.vm.provision "shell", path: "ansible/bootstrap.sh", args: "devcloud"
    end
end
