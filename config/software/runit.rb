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
require 'erb'

name "runit"
version "2.1.1"

source :url => "http://smarden.org/runit/runit-#{version}.tar.gz",
       :md5 => "8fa53ea8f71d88da9503f62793336bc3"

relative_path "admin"

working_dir = "#{project_dir}/runit-#{version}"

service_path = File.join(install_dir, 'service')
sv_path = File.join(install_dir, 'sv')
install_prefix = File.join(install_dir, "embedded")
gem_bin = File.join(install_dir, 'bin', 'gem')
scripts_dir = File.join(Omnibus.project_root, 'runit_scripts')

build do
  # put runit where we want it, not where they tell us to
  command 'sed -i -e "s/^char\ \*varservice\ \=\"\/service\/\";$/char\ \*varservice\ \=\"' + project.install_path.gsub("/", "\\/") + '\/service\/\";/" src/sv.c', :cwd => working_dir
  # TODO: the following is not idempotent
  command "sed -i -e s:-static:: src/Makefile", :cwd => working_dir

  # build it
  command "make", :cwd => "#{working_dir}/src"
  command "make check", :cwd => "#{working_dir}/src"

  # move it
  command "mkdir -p #{install_dir}/embedded/bin"
  ["chpst",
   "runsv",
   "runsvdir",
   "sv",
   "svlogd",
   "utmpset"].each do |bin|
    command "cp #{bin} #{install_dir}/embedded/bin", :cwd => working_dir
  end

  #move scripts
  command "cp -f #{scripts_dir}/sensu-runsvdir.sh #{install_prefix}/bin/sensu-runsvdir"
  command "chmod 755 #{install_prefix}/bin/sensu-runsvdir"

  # need ohai and systemu for sensu-ctl
  gem "install ohai -v 6.16.0 --no-ri --no-rdoc"
  gem "install systemu -v 2.5.2 --no-ri --no-rdoc"

  command "cp -f #{scripts_dir}/sensu-ctl.rb #{install_prefix}/bin/sensu-ctl"
  command "chmod 0755 #{install_prefix}/bin/sensu-ctl"

  # set up service directories
  ["#{install_dir}/service",
   "#{install_dir}/sv"].each do |dir|
    command "mkdir -p #{dir}"
  end

  unless platform == 'windows'
    block do
      ["client","server","api","dashboard"].each do |sv|
        FileUtils.mkdir_p("#{sv_path}/sensu-#{sv}/supervise")
        File.open("#{scripts_dir}/sensu-sv-run.sh.erb") do |template|
          @sv = sv
          erb = ERB.new(template.read)
          File.open("#{sv_path}/sensu-#{sv}/run", 'w') do |file|
            file.write(erb.result(binding))
          end
        end
      command "mkdir -p #{sv_path}/sensu-#{sv}/log/main"
      command "cp -f #{scripts_dir}/sensu-sv-log.sh #{sv_path}/sensu-#{sv}/log/run"
      command "chmod 0755 #{sv_path}/sensu-#{sv}/run #{sv_path}/sensu-#{sv}/log/run"
      end
    end
  end
end
