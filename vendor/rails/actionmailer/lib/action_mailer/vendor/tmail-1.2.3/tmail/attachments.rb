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

=begin rdoc

= Attachment handling file

=end

require 'stringio'

module TMail
  class Attachment < StringIO
    attr_accessor :original_filename, :content_type
  end

  class Mail
    def has_attachments?
      multipart? && parts.any? { |part| attachment?(part) }
    end

    def attachment?(part)
      part.disposition_is_attachment? || part.content_type_is_text?
    end

    def attachments
      if multipart?
        parts.collect { |part| 
          if part.multipart?
            part.attachments
          elsif attachment?(part)
            content   = part.body # unquoted automatically by TMail#body
            file_name = (part['content-location'] &&
                          part['content-location'].body) ||
                        part.sub_header("content-type", "name") ||
                        part.sub_header("content-disposition", "filename")
            
            next if file_name.blank? || content.blank?
            
            attachment = Attachment.new(content)
            attachment.original_filename = file_name.strip
            attachment.content_type = part.content_type
            attachment
          end
        }.flatten.compact
      end      
    end
  end
end
