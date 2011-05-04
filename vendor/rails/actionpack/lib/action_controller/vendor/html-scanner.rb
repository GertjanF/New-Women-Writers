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

$LOAD_PATH << "#{File.dirname(__FILE__)}/html-scanner"

module HTML
  autoload :CDATA, 'html/node'
  autoload :Document, 'html/document'
  autoload :FullSanitizer, 'html/sanitizer'
  autoload :LinkSanitizer, 'html/sanitizer'
  autoload :Node, 'html/node'
  autoload :Sanitizer, 'html/sanitizer'
  autoload :Selector, 'html/selector'
  autoload :Tag, 'html/node'
  autoload :Text, 'html/node'
  autoload :Tokenizer, 'html/tokenizer'
  autoload :Version, 'html/version'
  autoload :WhiteListSanitizer, 'html/sanitizer'
end
