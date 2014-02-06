name "sensu-plugin"

dependency "ruby"

gem_version = "0.1.7"
version "v#{gem_version}"

source :git => "git://github.com/sensu/sensu-plugin"

gem_bin = "#{install_dir}/embedded/bin/gem"

env = {
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
      }

build do
  command "rm -f sensu-plugin-#{gem_version}"
  gem "build sensu-plugin.gemspec", :env => env
  gem "install --no-ri --no-rdoc sensu-plugin-#{gem_version}.gem", :env => env
end
