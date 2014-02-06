
name "readline"
version "6.2"

source :url => "ftp://ftp.cwru.edu/pub/bash/readline-#{version}.tar.gz",
       :md5 => "67948acb2ca081f23359d0256e9a271c"

relative_path "readline-#{version}"
env = {
        "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib"
      }

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}"
  command "make -j #{max_build_jobs} install"
end
