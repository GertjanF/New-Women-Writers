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

class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :special_posts, :class_name => "Post"
  has_and_belongs_to_many :other_posts, :class_name => "Post"
  has_and_belongs_to_many :posts_with_authors_sorted_by_author_id, :class_name => "Post", :include => :authors, :order => "authors.id"

  has_and_belongs_to_many(:select_testing_posts,
                          :class_name => 'Post',
                          :foreign_key => 'category_id',
                          :association_foreign_key => 'post_id',
                          :select => 'posts.*, 1 as correctness_marker')

  has_and_belongs_to_many :post_with_conditions,
                          :class_name => 'Post',
                          :conditions => { :title => 'Yet Another Testing Title' }

  has_and_belongs_to_many :popular_grouped_posts, :class_name => "Post", :group => "posts.type", :having => "sum(comments.post_id) > 2", :include => :comments
  has_and_belongs_to_many :posts_gruoped_by_title, :class_name => "Post", :group => "title", :select => "title"

  def self.what_are_you
    'a category...'
  end

  has_many :categorizations
  has_many :authors, :through => :categorizations, :select => 'authors.*, categorizations.post_id'
end

class SpecialCategory < Category

  def self.what_are_you
    'a special category...'
  end

end
