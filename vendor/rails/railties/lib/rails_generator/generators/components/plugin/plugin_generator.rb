#
# Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
#
# This file is part of New Women Writers.
#
# New Women Writers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# New Women Writers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
#

class PluginGenerator < Rails::Generator::NamedBase
  attr_reader :plugin_path

  def initialize(runtime_args, runtime_options = {})
    @with_generator = runtime_args.delete("--with-generator")
    super
    @plugin_path = "vendor/plugins/#{file_name}"
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_name

      m.directory "#{plugin_path}/lib"
      m.directory "#{plugin_path}/tasks"
      m.directory "#{plugin_path}/test"

      m.template 'README',         "#{plugin_path}/README"
      m.template 'MIT-LICENSE',    "#{plugin_path}/MIT-LICENSE"
      m.template 'Rakefile',       "#{plugin_path}/Rakefile"
      m.template 'init.rb',        "#{plugin_path}/init.rb"
      m.template 'install.rb',     "#{plugin_path}/install.rb"
      m.template 'uninstall.rb',   "#{plugin_path}/uninstall.rb"
      m.template 'plugin.rb',      "#{plugin_path}/lib/#{file_name}.rb"
      m.template 'tasks.rake',     "#{plugin_path}/tasks/#{file_name}_tasks.rake"
      m.template 'unit_test.rb',   "#{plugin_path}/test/#{file_name}_test.rb"
      m.template 'test_helper.rb', "#{plugin_path}/test/test_helper.rb"
      if @with_generator
        m.directory "#{plugin_path}/generators"
        m.directory "#{plugin_path}/generators/#{file_name}"
        m.directory "#{plugin_path}/generators/#{file_name}/templates"

        m.template 'generator.rb', "#{plugin_path}/generators/#{file_name}/#{file_name}_generator.rb"
        m.template 'USAGE',        "#{plugin_path}/generators/#{file_name}/USAGE"
      end
    end
  end
end
