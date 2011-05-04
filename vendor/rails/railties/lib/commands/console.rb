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

irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'

require 'optparse'

options = { :sandbox => false, :irb => irb }
OptionParser.new do |opt|
  opt.banner = "Usage: console [environment] [options]"
  opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
  opt.on("--irb=[#{irb}]", 'Invoke a different irb.') { |v| options[:irb] = v }
  opt.on("--debugger", 'Enable ruby-debugging for the console.') { |v| options[:debugger] = v }
  opt.parse!(ARGV)
end

libs =  " -r irb/completion"
libs << %( -r "#{RAILS_ROOT}/config/environment")
libs << " -r console_app"
libs << " -r console_sandbox" if options[:sandbox]
libs << " -r console_with_helpers"

if options[:debugger]
  begin
    require 'ruby-debug'
    libs << " -r ruby-debug"
    puts "=> Debugger enabled"
  rescue Exception
    puts "You need to install ruby-debug to run the console in debugging mode. With gems, use 'gem install ruby-debug'"
    exit
  end
end

ENV['RAILS_ENV'] = case ARGV.first
  when "p"; "production"
  when "d"; "development"
  when "t"; "test"
  else
    ARGV.first || ENV['RAILS_ENV'] || 'development'
end

if options[:sandbox]
  puts "Loading #{ENV['RAILS_ENV']} environment in sandbox (Rails #{Rails.version})"
  puts "Any modifications you make will be rolled back on exit"
else
  puts "Loading #{ENV['RAILS_ENV']} environment (Rails #{Rails.version})"
end
exec "#{options[:irb]} #{libs} --simple-prompt"
