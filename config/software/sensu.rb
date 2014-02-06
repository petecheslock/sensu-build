name "sensu"

dependency "ruby"
dependency "bundler"

version "v#{ENV["SENSU_VERSION"]}"

source :git => "git://github.com/sensu/sensu"

gem_bin = "#{install_dir}/embedded/bin/gem"

env = {
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
      }

build do
  bundle "install --without development", :env => env
end
