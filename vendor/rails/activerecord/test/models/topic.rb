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

class Topic < ActiveRecord::Base
  named_scope :base
  named_scope :written_before, lambda { |time|
    if time
      { :conditions => ['written_on < ?', time] }
    end
  }
  named_scope :approved, :conditions => {:approved => true}
  named_scope :rejected, :conditions => {:approved => false}

  named_scope :by_lifo, :conditions => {:author_name => 'lifo'}
  
  named_scope :approved_as_hash_condition, :conditions => {:topics => {:approved => true}}
  named_scope 'approved_as_string', :conditions => {:approved => true}
  named_scope :replied, :conditions => ['replies_count > 0']
  named_scope :anonymous_extension do
    def one
      1
    end
  end
  module NamedExtension
    def two
      2
    end
  end
  module MultipleExtensionOne
    def extension_one
      1
    end
  end
  module MultipleExtensionTwo
    def extension_two
      2
    end
  end
  named_scope :named_extension, :extend => NamedExtension
  named_scope :multiple_extensions, :extend => [MultipleExtensionTwo, MultipleExtensionOne]

  has_many :replies, :dependent => :destroy, :foreign_key => "parent_id"
  has_many :replies_with_primary_key, :class_name => "Reply", :dependent => :destroy, :primary_key => "title", :foreign_key => "parent_title"
  serialize :content

  before_create  :default_written_on
  before_destroy :destroy_children

  def parent
    Topic.find(parent_id)
  end

  # trivial method for testing Array#to_xml with :methods
  def topic_id
    id
  end

  protected
    def approved=(val)
      @custom_approved = val
      write_attribute(:approved, val)
    end

    def default_written_on
      self.written_on = Time.now unless attribute_present?("written_on")
    end

    def destroy_children
      self.class.delete_all "parent_id = #{id}"
    end

    def after_initialize
      if self.new_record?
        self.author_email_address = 'test@test.com'
      end
    end
end

module Web
  class Topic < ActiveRecord::Base
    has_many :replies, :dependent => :destroy, :foreign_key => "parent_id", :class_name => 'Web::Reply'
  end
end