
name "sensu"
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
dependency "sensu"
dependency "sensu-dashboard"
dependency "sensu-plugin"
dependency "sensu-binstubs"
dependency "sensu-configs"

# version manifest file
dependency "version-manifest"

#Array of Config-files
config_files = ["/etc/sensu/config.json.example",
                "/etc/sensu/conf.d/README.md",
                "/etc/logrotate.d/sensu",
                "/etc/init.d/sensu-service",
                "/etc/init.d/sensu-api",
                "/etc/init.d/sensu-client",
                "/etc/init.d/sensu-server",
                "/etc/init.d/sensu-dashboard"]

exclude "\.git*"
exclude "bundler\/git"
