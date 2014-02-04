# -*- mode: ruby -*-
# vi: set ft=ruby :

if Vagrant::VERSION < "1.5.0"
# This is fixed as part of vagrant 1.5 - monkeypatch it here
# This allows freebsd NFS shared folders to work
  require Vagrant.source_root.join("plugins", "provisioners", "chef", "provisioner", "chef_solo")
  class VagrantPlugins::Chef::Provisioner::ChefSolo
    def share_folders(root_config, prefix, folders)
      folders.each do |type, local_path, remote_path|
        if type == :host
          root_config.vm.synced_folder(
          local_path, remote_path,
          :id =>  "v-#{prefix}-#{self.class.get_and_update_counter(:shared_folder)}",
          :type => (@config.nfs ? :nfs : nil))
        end
      end
    end
  end
end
