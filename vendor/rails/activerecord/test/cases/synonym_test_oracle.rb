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

require "cases/helper"
require 'models/topic'
require 'models/subject'

# confirm that synonyms work just like tables; in this case
# the "subjects" table in Oracle (defined in oci.sql) is just
# a synonym to the "topics" table

class TestOracleSynonym < ActiveRecord::TestCase

  def test_oracle_synonym
    topic = Topic.new
    subject = Subject.new
    assert_equal(topic.attributes, subject.attributes)
  end

end
