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

require 'libxml'

# = XmlMini LibXML implementation
module ActiveSupport
  module XmlMini_LibXML #:nodoc:
    extend self

    # Parse an XML Document string into a simple hash using libxml.
    # string::
    #   XML Document string to parse
    def parse(string)
      LibXML::XML.default_keep_blanks = false

      if string.blank?
        {}
      else
        LibXML::XML::Parser.string(string.strip).parse.to_hash
      end
    end

  end
end

module LibXML
  module Conversions
    module Document
      def to_hash
        root.to_hash
      end
    end

    module Node
      CONTENT_ROOT = '__content__'
      LIB_XML_LIMIT = 30000000 # Hardcoded LibXML limit

      # Convert XML document to hash
      #
      # hash::
      #   Hash to merge the converted element into.
      def to_hash(hash={})
        if text?
          raise LibXML::XML::Error if content.length >= LIB_XML_LIMIT
          hash[CONTENT_ROOT] = content
        else
          sub_hash = insert_name_into_hash(hash, name)
          attributes_to_hash(sub_hash)
          if array?
            children_array_to_hash(sub_hash)
          elsif yaml?
            children_yaml_to_hash(sub_hash)
          else
            children_to_hash(sub_hash)
          end
        end
        hash
      end

      protected

        # Insert name into hash
        #
        # hash::
        #   Hash to merge the converted element into.
        # name::
        #   name to to merge into hash
        def insert_name_into_hash(hash, name)
          sub_hash = {}
          if hash[name]
            if !hash[name].kind_of? Array
              hash[name] = [hash[name]]
            end
            hash[name] << sub_hash
          else
            hash[name] = sub_hash
          end
          sub_hash
        end

        # Insert children into hash
        #
        # hash::
        #   Hash to merge the children into.
        def children_to_hash(hash={})
          each { |child| child.to_hash(hash) }
          attributes_to_hash(hash)
          hash
        end

        # Convert xml attributes to hash
        #
        # hash::
        #   Hash to merge the attributes into
        def attributes_to_hash(hash={})
          each_attr { |attr| hash[attr.name] = attr.value }
          hash
        end

        # Convert array into hash
        #
        # hash::
        #   Hash to merge the array into
        def children_array_to_hash(hash={})
          hash[child.name] = map do |child|
            returning({}) { |sub_hash| child.children_to_hash(sub_hash) }
          end
          hash
        end

        # Convert yaml into hash
        #
        # hash::
        #   Hash to merge the yaml into
        def children_yaml_to_hash(hash = {})
          hash[CONTENT_ROOT] = content unless content.blank?
          hash
        end

        # Check if child is of type array
        def array?
          child? && child.next? && child.name == child.next.name
        end

        # Check if child is of type yaml
        def yaml?
          attributes.collect{|x| x.value}.include?('yaml')
        end

    end
  end
end

LibXML::XML::Document.send(:include, LibXML::Conversions::Document)
LibXML::XML::Node.send(:include, LibXML::Conversions::Node)
