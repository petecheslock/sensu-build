
name "sensu"
maintainer "CHANGE ME"
homepage "CHANGEME.com"

replaces        "sensu"
install_path    "/opt/sensu"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

# sensu dependencies/components
# dependency "somedep"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
