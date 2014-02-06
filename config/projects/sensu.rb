
name 'sensu'
maintainer 'sensuapp.org'
homepage 'sensuapp.org'

replaces        'sensu'
install_path    '/opt/sensu'
build_version   ENV['SENSU_VERSION']
build_iteration ENV['BUILD_NUMBER']

# creates required build directories
dependency 'preparation'

# sensu dependencies/components
dependency 'ruby'
dependency 'runit'
dependency 'sensu'
dependency 'sensu-dashboard'
dependency 'sensu-plugin'
#dependency 'sensu-configs'
#dependency 'sensu-binstubs'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
