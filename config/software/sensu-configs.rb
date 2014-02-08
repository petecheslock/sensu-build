name "sensu-configs"

sensu_config = "#{Omnibus.project_root}/sensu_configs"

build do
  command "rm -rf /etc/sensu"
  command "rm -rf /etc/default/sensu"
  command "rm -rf /etc/init.d/sensu-*"
  command "rm -rf /usr/share/sensu"
  command "rm -rf /var/log/sensu"
  command "cp -rf #{sensu_config}/sensu /etc/sensu"
  command "cp -rf #{sensu_config}/default/* /etc/default/"
  command "cp -rf #{sensu_config}/logrotate.d/* /etc/logrotate.d/"
  command "cp -rf #{sensu_config}/init.d/* /etc/init.d/"
  command "mkdir /usr/share/sensu"
  command "cp -rf ./sensu_configs/init.d /usr/share/sensu/"
  command "cp -rf ./sensu_configs/upstart /usr/share/sensu/"
  command "cp -rf ./sensu_configs/systemd /usr/share/sensu/"
  command "mkdir /var/log/sensu"

  %w[plugins mutators handlers extensions].each do |dir|
    command "mkdir /etc/sensu/#{dir}"
  end
end
