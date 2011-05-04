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

require 'rbconfig'
require 'find'
require 'ftools'

include Config

# this was adapted from rdoc's install.rb by ways of Log4r

$sitedir = CONFIG["sitelibdir"]
unless $sitedir
  version = CONFIG["MAJOR"] + "." + CONFIG["MINOR"]
  $libdir = File.join(CONFIG["libdir"], "ruby", version)
  $sitedir = $:.find {|x| x =~ /site_ruby/ }
  if !$sitedir
    $sitedir = File.join($libdir, "site_ruby")
  elsif $sitedir !~ Regexp.quote(version)
    $sitedir = File.join($sitedir, version)
  end
end

# the actual gruntwork
Dir.chdir("lib")

Find.find("active_record", "active_record.rb") { |f|
  if f[-3..-1] == ".rb"
    File::install(f, File.join($sitedir, *f.split(/\//)), 0644, true)
  else
    File::makedirs(File.join($sitedir, *f.split(/\//)))
  end
}
