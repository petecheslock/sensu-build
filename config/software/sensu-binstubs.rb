name "sensu-binstubs"

bin_dir = "#{install_dir}/bin"

build do
  command "rm -rf #{bin_dir}"
  command "mkdir -p #{bin_dir}"
  command "ln -s #{install_dir}/embedded/bin/sensu-api #{bin_dir}/sensu-api"
  command "ln -s #{install_dir}/embedded/bin/sensu-client #{bin_dir}/sensu-client"
  command "ln -s #{install_dir}/embedded/bin/sensu-server #{bin_dir}/sensu-server"
  command "ln -s #{install_dir}/embedded/bin/sensu-dashboard #{bin_dir}/sensu-dashboard"
  command "ln -s #{install_dir}/embedded/bin/sensu-ctl #{bin_dir}/sensu-ctl"
end
