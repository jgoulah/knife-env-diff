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
  class EnvDiff < Chef::Knife

    banner "knife env-diff [ENVIRONMENTS...]"

    def run
      if name_args.size < 2
        ui.error("You need to supply at least two environments")
        show_usage
        exit 1
      end

      firstenv  = name_args.first
      otherenvs = name_args.slice(1, name_args.length - 1)

      from_env   = {}
      env = load_environment(firstenv)
      from_env[firstenv] = env.cookbook_versions

      to_env   = {}
      otherenvs.each do |env_name|
        env = load_environment(env_name)
        to_env[env_name] = env.cookbook_versions
      end

      ui.msg "diffing environment " + firstenv + " against " + otherenvs.join(', ') + "\n\n"

      from_env.each_value do |from_cookbooks|
        from_cookbooks.each do |from_cookbook, from_version|

          diff_versions = {}

          to_env.each do |to_env, to_cookbooks|
            to_version = to_cookbooks[from_cookbook] || "missing"
            if from_version != to_version
              diff_versions[to_env] = to_version
            end
          end

          unless diff_versions.empty?
            ui.msg "cookbook: "+ from_cookbook
            ui.msg " #{firstenv} version: "+ from_version
            diff_versions.each do |env, version|
              ui.msg " #{env} version: "+ version
            end
            ui.msg "\n"
          end

        end
      end

    end

    def load_environment(env)
      e = Chef::Environment.load(env)
      return e
      rescue Net::HTTPServerException => e
        if e.response.code.to_s == "404"
          ui.error "The environment #{env} does not exist on the server, aborting."
          Chef::Log.debug(e)
          exit 1
        else
          raise
        end
   end

  end
end
