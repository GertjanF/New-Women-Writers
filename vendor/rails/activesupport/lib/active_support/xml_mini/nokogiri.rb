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

require 'nokogiri'

# = XmlMini Nokogiri implementation
module ActiveSupport
  module XmlMini_Nokogiri #:nodoc:
    extend self

    # Parse an XML Document string into a simple hash using libxml / nokogiri.
    # string::
    #   XML Document string to parse
    def parse(string)
      if string.blank?
        {}
      else
        doc = Nokogiri::XML(string)
        raise doc.errors.first if doc.errors.length > 0
        doc.to_hash
      end
    end

    module Conversions
      module Document
        def to_hash
          root.to_hash
        end
      end

      module Node
        CONTENT_ROOT = '__content__'

        # Convert XML document to hash
        #
        # hash::
        #   Hash to merge the converted element into.
        def to_hash(hash = {})
          hash[name] ||= attributes_as_hash

          walker = lambda { |memo, parent, child, callback|
            next if child.blank? && 'file' != parent['type']

            if child.text?
              (memo[CONTENT_ROOT] ||= '') << child.content
              next
            end

            name = child.name

            child_hash = child.attributes_as_hash
            if memo[name]
              memo[name] = [memo[name]].flatten
              memo[name] << child_hash
            else
              memo[name] = child_hash
            end

            # Recusively walk children
            child.children.each { |c|
              callback.call(child_hash, child, c, callback)
            }
          }

          children.each { |c| walker.call(hash[name], self, c, walker) }
          hash
        end

        def attributes_as_hash
          Hash[*(attribute_nodes.map { |node|
            [node.node_name, node.value]
          }.flatten)]
        end
      end
    end

    Nokogiri::XML::Document.send(:include, Conversions::Document)
    Nokogiri::XML::Node.send(:include, Conversions::Node)
  end
end
