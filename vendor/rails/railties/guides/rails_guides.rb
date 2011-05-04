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

pwd = File.dirname(__FILE__)
$: << pwd

begin
  as_lib = File.join(pwd, "../../activesupport/lib")
  ap_lib = File.join(pwd, "../../actionpack/lib")

  $: << as_lib if File.directory?(as_lib)
  $: << ap_lib if File.directory?(ap_lib)
  
  require "action_controller"
  require "action_view"
rescue LoadError
  require 'rubygems'
  gem "actionpack", '>= 2.3'

  require "action_controller"
  require "action_view"
end

begin
  require 'rubygems'
  gem 'RedCloth', '>= 4.1.1'
rescue Gem::LoadError
  $stderr.puts %(Generating Guides requires RedCloth 4.1.1+)
  exit 1
end

require 'redcloth'

module RailsGuides
  autoload :Generator, "rails_guides/generator"
  autoload :Indexer, "rails_guides/indexer"
  autoload :Helpers, "rails_guides/helpers"
  autoload :TextileExtensions, "rails_guides/textile_extensions"
end

RedCloth.send(:include, RailsGuides::TextileExtensions)

if $0 == __FILE__
  RailsGuides::Generator.new.generate
end
