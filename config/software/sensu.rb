name "sensu"

dependency "ruby"

version ENV["SENSU_VERSION"]

env = {
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
      }

build do
  gem "install sensu -v #{version} --no-ri --no-rdoc", :env => env
end
