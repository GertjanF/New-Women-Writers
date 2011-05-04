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

commands = Dir["#{File.dirname(__FILE__)}/commands/*.rb"].collect { |file_path| File.basename(file_path).split(".").first }

if commands.include?(ARGV.first)
  require "#{File.dirname(__FILE__)}/commands/#{ARGV.shift}"
else
  puts <<-USAGE
The 'run' provides a unified access point for all the default Rails' commands.
  
Usage: ./script/run <command> [OPTIONS]

Examples:
  ./script/run generate controller Admin
  ./script/run process reaper

USAGE
  puts "Choose: #{commands.join(", ")}"
end