# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.join(File.dirname(__FILE__), 'vagrant_patches')

if ENV['SENSU_VERSION'].nil?
  raise "Must set env var 'SENSU_VERSION'"
end

if ENV['BUILD_NUMBER'].nil?
  raise "Must set env var 'BUILD_NUMBER'"
end


build_boxes = {
  # 'centos_5_64'    => 'http://vagrant.sensuapp.org/centos-5-x86_64.box',
  # 'centos_5_32'    => 'http://vagrant.sensuapp.org/centos-5-i386.box',
  # 'centos_6_64'    => 'http://vagrant.sensuapp.org/centos-6-x86_64.box',
  # 'centos_6_32'    => 'http://vagrant.sensuapp.org/centos-6-i386.box',
  # 'ubuntu_1004_32' => 'http://vagrant.sensuapp.org/ubuntu-1004-i386.box',
  # 'ubuntu_1004_64' => 'http://vagrant.sensuapp.org/ubuntu-1004-amd64.box',
  # 'ubuntu_1104_32' => 'http://vagrant.sensuapp.org/ubuntu-1104-i386.box',
  # 'ubuntu_1104_64' => 'http://vagrant.sensuapp.org/ubuntu-1104-amd64.box',
  # 'ubuntu_1110_32' => 'http://vagrant.sensuapp.org/ubuntu-1110-i386.box',
  # 'ubuntu_1110_64' => 'http://vagrant.sensuapp.org/ubuntu-1110-amd64.box',
  # 'ubuntu_1204_32' => 'http://vagrant.sensuapp.org/ubuntu-1204-i386.box',
    'ubuntu_1204_64' => 'http://vagrant.sensuapp.org/ubuntu-1204-amd64.box',
  # 'debian_6_32'    => 'http://vagrant.sensuapp.org/debian-6-i386.box',
  # 'debian_6_64'    => 'http://vagrant.sensuapp.org/debian-6-amd64.box',
  # 'fedora_17_32'   => 'http://vagrant.sensuapp.org/fedora-17-i386.box',
  # 'fedora_17_64'   => 'http://vagrant.sensuapp.org/fedora-17-x86_64.box',
    'freebsd_91_64'  => 'http://dyn-vm.s3.amazonaws.com/vagrant/freebsd-9.1_provisionerless.box'
  # 'debian_5_32'    => '',
  # 'debian_5_64'    => '',
  # 'opensuse_1201_64' => '',
  # 'sles_11sp2_64'    => ''
}

host_project_path = File.expand_path("..", __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = 'sensu'
bootstrap_chef_version = '11.8.0'

Vagrant.configure('2') do |config|

  build_boxes.each_with_index do |(platform, url), index|

    config.vm.define platform do |c|

      case platform

      ####################################################################
      # FREEBSD-SPECIFIC CONFIG
      ####################################################################
      when /^freebsd/

        use_nfs = true

        # FreeBSD's mount_nfs does not like paths over 88 characters
        # http://lists.freebsd.org/pipermail/freebsd-hackers/2012-April/038547.html
        ENV['BERKSHELF_PATH'] = File.join('/tmp')

        major_version = platform.split(/freebsd-(.*)\..*/).last

        c.vm.guest = :freebsd
        c.vm.box = platform
        c.vm.box_url = url
        c.omnibus.chef_version = bootstrap_chef_version
        c.vm.network :private_network, :ip => "33.33.33.#{50 + index}"

        c.vm.provision :shell, :inline => <<-FREEBSD_SETUP
          sed -i '' -E 's%^([^#].*):setenv=%\1:setenv=PACKAGESITE=ftp://ftp.freebsd.org/pub/FreeBSD/ports/amd64/packages-#{major_version}-stable/Latest,%' /etc/login.conf
        FREEBSD_SETUP

      ####################################################################
      # LINUX-SPECIFIC CONFIG
      ####################################################################
      else
        use_nfs = false

        c.vm.box = platform
        c.vm.box_url = url
        c.omnibus.chef_version = bootstrap_chef_version

        c.vm.provider :virtualbox do |vb|
          # Give enough horsepower to build without taking all day.
          vb.customize [
            'modifyvm', :id,
            '--memory', '1024',
            '--cpus', '1'
          ]
        end

      end # case

      ####################################################################
      # CONFIG SHARED ACROSS ALL PLATFORMS
      ####################################################################

      config.berkshelf.enabled = true
      config.ssh.forward_agent = true

      config.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :nfs => use_nfs
      config.vm.synced_folder host_project_path, guest_project_path, :nfs => use_nfs

      config.vm.host_name = "sensu-build-#{platform.tr('_','-')}"

      # Uncomment for DEV MODE
      # config.vm.synced_folder File.expand_path('../../omnibus-ruby', __FILE__), '/home/vagrant/omnibus-ruby', :nfs => use_nfs
      # config.vm.synced_folder File.expand_path('../../omnibus-software', __FILE__), '/home/vagrant/omnibus-software', :nfs => use_nfs

      # prepare VM to be an Omnibus builder
      c.vm.provision :chef_solo do |chef|
        chef.nfs = use_nfs
        chef.json = {
          'omnibus' => {
            'build_user' => 'vagrant',
            'build_dir' => guest_project_path,
            'install_dir' => "/opt/#{project_name}"
          }
        }

        chef.run_list = [
          'recipe[omnibus::default]'
        ]
      end

      c.vm.provision :shell, :inline => <<-OMNIBUS_BUILD
        sudo mkdir -p /opt/#{project_name}
        sudo chown vagrant /opt/#{project_name}
        export PATH=/usr/local/bin:$PATH
        cd #{guest_project_path}
        sudo su vagrant -c "bundle install --path=/home/vagrant/.bundler"
        export SENSU_VERSION=#{ENV['SENSU_VERSION']}
        export BUILD_NUMBER=#{ENV['BUILD_NUMBER']}
        sudo su vagrant -c "bundle exec omnibus build project #{project_name}"
      OMNIBUS_BUILD

    end # config.vm.define.platform
  end # each_pair.with_index
end # Vagrant.configure
