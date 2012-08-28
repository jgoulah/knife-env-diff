#
# Author:: John Goulah (<jgoulah@gmail.com>)
# Copyright:: Copyright (c) 2011 John Goulah
#
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
#

module GoulahKnifePlugins
  class EnvironmentDiff < Chef::Knife

    banner "knife environment diff [ENVIRONMENTS...]"

    def run
      if name_args.size < 2
        ui.error("You need to supply at least two environments")
        show_usage
        exit 1
      end

      firstenv  = name_args.first
      otherenvs = name_args.slice(1, name_args.length - 1)

      from_env   = {}
      from_env[firstenv] = get_env_cookbooks(firstenv)

      to_env   = {}
      otherenvs.each do |env_name|
        to_env[env_name] = get_env_cookbooks(env_name)
      end

      ui.msg "diffing environment " + firstenv + " against " + otherenvs.join(', ') + "\n\n"

      from_env.each_value do |from_cookbooks|
        from_cookbooks.each do |from_cookbook, from_data|
          diff_versions = {}

          from_version = get_cookbook_version(from_data)

          to_env.each do |env, to_cookbooks|
            to_version = get_cookbook_version(to_cookbooks[from_cookbook])

            if from_version != to_version || from_version.nil?
              diff_versions[env] = to_version
            end
          end

          unless diff_versions.empty?
            ui.msg "cookbook: "+ from_cookbook
            ui.msg " #{firstenv} version: #{from_version}"
            diff_versions.each do |env, version|
              ui.msg " #{env} version: "+ version
            end
            ui.msg "\n"
          end
        end
      end
    end

    def get_env_cookbooks(env)
      rest.get_rest("environments/#{env}/cookbooks")
    end

    def get_cookbook_version(data)
      if data['versions'].empty?
        'none'
      else
        data['versions'].first['version']
      end
    end
  end
end
