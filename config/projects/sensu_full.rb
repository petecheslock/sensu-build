
name "sensu_full"
maintainer "sensuapp.org"
homepage "sensuapp.org"

replaces        "sensu"
install_path    "/opt/sensu"
build_version   ENV["SENSU_VERSION"]
build_iteration ENV["BUILD_NUMBER"]

# creates required build directories
dependency "preparation"

# sensu dependencies/components
dependency "ruby"
dependency "runit"
dependency "rabbitmq"
dependency "redis"
dependency "sensu"
dependency "sensu-dashboard"
dependency "sensu-plugin"
dependency "sensu-binstubs"
dependency "sensu-configs"

# version manifest file
dependency "version-manifest"

file "/usr/share/sensu"
file "/var/log/sensu"
file "/etc/sensu"
file "/etc/default/sensu"
file "/etc/init.d/sensu-service"
file "/etc/init.d/sensu-api"
file "/etc/init.d/sensu-client"
file "/etc/init.d/sensu-server"
file "/etc/init.d/sensu-dashboard"
file "/etc/logrotate.d/sensu"

config_file "/etc/sensu/config.json.example"
config_file "/etc/sensu/conf.d/README.md"
config_file "/etc/logrotate.d/sensu"

exclude "\.git*"
exclude "bundler\/git"
