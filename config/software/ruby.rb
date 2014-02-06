#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "ruby"
version "2.0.0-p353"

dependency "autoconf"
dependency "zlib"
dependency "ncurses"
dependency "libedit"
dependency "openssl"
dependency "libyaml"
dependency "readline"
dependency "gdbm" if platform == "freebsd"

source :url => "http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-#{version}.tar.gz",
       :md5 => "78282433fb697dd3613613ff55d734c1"

relative_path "ruby-#{version}"
install_prefix = "#{install_dir}/embedded"

env = {
        "CFLAGS" => "-L#{install_prefix}/lib -I#{install_prefix}/include",
        "LDFLAGS" => "-Wl,-rpath #{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
      }

build do
  configure_command = ["./configure",
                       "--prefix=#{install_prefix}",
                       "--with-opt-dir=#{install_prefix}",
                       "--enable-shared",
                       "--disable-install-doc"]

  configure_command << "--without-execinfo" if platform == "freebsd"

  # @todo expose bundle_bust() in the DSL
  env.merge!({
    "RUBYOPT"         => nil,
    "BUNDLE_BIN_PATH" => nil,
    "BUNDLE_GEMFILE"  => nil,
    "GEM_PATH"        => nil,
    "GEM_HOME"        => nil
  })

  # @todo: move into omnibus-ruby
  has_gmake = system("gmake --version")

  if has_gmake
    env.merge!({'MAKE' => 'gmake'})
    make_binary = 'gmake'
  else
    make_binary = 'make'
  end

  command configure_command.join(" "), :env => env
  command "#{make_binary} -j #{max_build_jobs}", :env => env
  command "#{make_binary} -j #{max_build_jobs} install", :env => env
end
