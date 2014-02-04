name "sensu"
version ENV['SENSU_VERSION']

dependency "ruby"
dependency "rubygems"

build do
  gem "install sensu -n #{install_dir}/embedded/bin --no-rdoc --no-ri -v #{version}"
end
