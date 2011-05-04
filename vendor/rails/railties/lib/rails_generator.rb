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

$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__) + "/../../activesupport/lib")

begin
  require 'active_support'  
rescue LoadError
  require 'rubygems'
  gem 'activesupport'
end

require 'rails_generator/base'
require 'rails_generator/lookup'
require 'rails_generator/commands'

Rails::Generator::Base.send(:include, Rails::Generator::Lookup)
Rails::Generator::Base.send(:include, Rails::Generator::Commands)

# Set up a default logger for convenience.
require 'rails_generator/simple_logger'
Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new(STDOUT)
