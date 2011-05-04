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

module MailHelper
  # Uses Text::Format to take the text and format it, indented two spaces for
  # each line, and wrapped at 72 columns.
  def block_format(text)
    formatted = text.split(/\n\r\n/).collect { |paragraph| 
      Text::Format.new(
        :columns => 72, :first_indent => 2, :body_indent => 2, :text => paragraph
      ).format
    }.join("\n")
    
    # Make list points stand on their own line
    formatted.gsub!(/[ ]*([*]+) ([^*]*)/) { |s| "  #{$1} #{$2.strip}\n" }
    formatted.gsub!(/[ ]*([#]+) ([^#]*)/) { |s| "  #{$1} #{$2.strip}\n" }

    formatted
  end
end
