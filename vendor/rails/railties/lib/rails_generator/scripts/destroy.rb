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

require File.dirname(__FILE__) + '/../scripts'

module Rails::Generator::Scripts
  class Destroy < Base
    mandatory_options :command => :destroy

    protected
    def usage_message
      usage = "\nInstalled Generators\n"
      Rails::Generator::Base.sources.each do |source|
        label = source.label.to_s.capitalize
        names = source.names
        usage << "  #{label}: #{names.join(', ')}\n" unless names.empty?
      end

      usage << <<end_blurb

script/generate command. For instance, 'script/destroy migration CreatePost'
will delete the appropriate XXX_create_post.rb migration file in db/migrate,
while 'script/destroy scaffold Post' will delete the posts controller and
views, post model and migration, all associated tests, and the map.resources
:posts line in config/routes.rb.

For instructions on finding new generators, run script/generate.
end_blurb
      return usage
    end
  end
end
