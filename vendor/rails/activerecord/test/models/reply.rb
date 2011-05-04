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

require 'models/topic'

class Reply < Topic
  named_scope :base

  belongs_to :topic, :foreign_key => "parent_id", :counter_cache => true
  belongs_to :topic_with_primary_key, :class_name => "Topic", :primary_key => "title", :foreign_key => "parent_title", :counter_cache => "replies_count"
  has_many :replies, :class_name => "SillyReply", :dependent => :destroy, :foreign_key => "parent_id"

  validate :errors_on_empty_content
  validate_on_create :title_is_wrong_create

  attr_accessible :title, :author_name, :author_email_address, :written_on, :content, :last_read, :parent_title

  def validate
    errors.add("title", "Empty")   unless attribute_present? "title"
  end

  def errors_on_empty_content
    errors.add("content", "Empty") unless attribute_present? "content"
  end

  def validate_on_create
    if attribute_present?("title") && attribute_present?("content") && content == "Mismatch"
      errors.add("title", "is Content Mismatch")
    end
  end

  def title_is_wrong_create
    errors.add("title", "is Wrong Create") if attribute_present?("title") && title == "Wrong Create"
  end

  def validate_on_update
    errors.add("title", "is Wrong Update") if attribute_present?("title") && title == "Wrong Update"
  end
end

class SillyReply < Reply
  belongs_to :reply, :foreign_key => "parent_id", :counter_cache => :replies_count
end

module Web
  class Reply < Web::Topic
    belongs_to :topic, :foreign_key => "parent_id", :counter_cache => true, :class_name => 'Web::Topic'
  end
end