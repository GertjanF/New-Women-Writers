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

# Fixes the rexml vulnerability disclosed at:
# http://www.ruby-lang.org/en/news/2008/08/23/dos-vulnerability-in-rexml/
# This fix is identical to rexml-expansion-fix version 1.0.1
require 'rexml/rexml'

# Earlier versions of rexml defined REXML::Version, newer ones REXML::VERSION
unless (defined?(REXML::VERSION) ? REXML::VERSION : REXML::Version) > "3.1.7.2"
  require 'rexml/document'

  # REXML in 1.8.7 has the patch but didn't update Version from 3.1.7.2.
  unless REXML::Document.respond_to?(:entity_expansion_limit=)
    require 'rexml/entity'

    module REXML
      class Entity < Child
        undef_method :unnormalized
        def unnormalized
          document.record_entity_expansion! if document
          v = value()
          return nil if v.nil?
          @unnormalized = Text::unnormalize(v, parent)
          @unnormalized
        end
      end
      class Document < Element
        @@entity_expansion_limit = 10_000
        def self.entity_expansion_limit= val
          @@entity_expansion_limit = val
        end

        def record_entity_expansion!
          @number_of_expansions ||= 0
          @number_of_expansions += 1
          if @number_of_expansions > @@entity_expansion_limit
            raise "Number of entity expansions exceeded, processing aborted."
          end
        end
      end
    end
  end
end
