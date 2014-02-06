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
end
