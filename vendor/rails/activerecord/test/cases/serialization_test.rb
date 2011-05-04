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
require 'models/contact'

class SerializationTest < ActiveRecord::TestCase
  FORMATS = [ :xml, :json ]

  def setup
    @contact_attributes = {
      :name        => 'aaron stack',
      :age         => 25,
      :avatar      => 'binarydata',
      :created_at  => Time.utc(2006, 8, 1),
      :awesome     => false,
      :preferences => { :gem => '<strong>ruby</strong>' }
    }

    @contact = Contact.new(@contact_attributes)
  end

  def test_serialize_should_be_reversible
    for format in FORMATS
      @serialized = Contact.new.send("to_#{format}")
      contact = Contact.new.send("from_#{format}", @serialized)

      assert_equal @contact_attributes.keys.collect(&:to_s).sort, contact.attributes.keys.collect(&:to_s).sort, "For #{format}"
    end
  end

  def test_serialize_should_allow_attribute_only_filtering
    for format in FORMATS
      @serialized = Contact.new(@contact_attributes).send("to_#{format}", :only => [ :age, :name ])
      contact = Contact.new.send("from_#{format}", @serialized)
      assert_equal @contact_attributes[:name], contact.name, "For #{format}"
      assert_nil contact.avatar, "For #{format}"
    end
  end

  def test_serialize_should_allow_attribute_except_filtering
    for format in FORMATS
      @serialized = Contact.new(@contact_attributes).send("to_#{format}", :except => [ :age, :name ])
      contact = Contact.new.send("from_#{format}", @serialized)
      assert_nil contact.name, "For #{format}"
      assert_nil contact.age, "For #{format}"
      assert_equal @contact_attributes[:awesome], contact.awesome, "For #{format}"
    end
  end
end
