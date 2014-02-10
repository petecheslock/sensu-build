name "sensu-configs"

sensu_configs = "#{Omnibus.project_root}/sensu_configs"

build do
  command "sudo mkdir /etc/sensu"
  command "sudo cp -rf #{sensu_configs}/sensu/* /etc/sensu"
  command "sudo cp -rf #{sensu_configs}/default/* /etc/default/"
  command "sudo cp -rf #{sensu_configs}/logrotate.d/* /etc/logrotate.d/"
  command "sudo cp -rf #{sensu_configs}/init.d/* /etc/init.d/"
  command "sudo mkdir /usr/share/sensu"
  command "sudo cp -rf #{sensu_configs}/init.d /usr/share/sensu/"
  command "sudo cp -rf #{sensu_configs}/upstart /usr/share/sensu/"
  command "sudo cp -rf #{sensu_configs}/systemd /usr/share/sensu/"
  command "sudo mkdir /var/log/sensu"

  %w[plugins mutators handlers extensions].each do |dir|
    command "sudo mkdir /etc/sensu/#{dir}"
  end
end
