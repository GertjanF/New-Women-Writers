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

class Comment < ActiveRecord::Base
  named_scope :containing_the_letter_e, :conditions => "comments.body LIKE '%e%'"
  named_scope :for_first_post, :conditions => { :post_id => 1 }
  named_scope :for_first_author,
              :joins => :post,
              :conditions => { "posts.author_id" => 1 }

  belongs_to :post, :counter_cache => true

  def self.what_are_you
    'a comment...'
  end

  def self.search_by_type(q)
    self.find(:all, :conditions => ["#{QUOTED_TYPE} = ?", q])
  end
end

class SpecialComment < Comment
  def self.what_are_you
    'a special comment...'
  end
end

class VerySpecialComment < Comment
  def self.what_are_you
    'a very special comment...'
  end
end
