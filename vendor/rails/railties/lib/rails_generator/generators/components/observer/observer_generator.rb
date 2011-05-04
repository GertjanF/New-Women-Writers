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

class ObserverGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions "#{class_name}Observer", "#{class_name}ObserverTest"

      # Observer, and test directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)

      # Observer class and unit test fixtures.
      m.template 'observer.rb',   File.join('app/models', class_path, "#{file_name}_observer.rb")
      m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{file_name}_observer_test.rb")
    end
  end
end
