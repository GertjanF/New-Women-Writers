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

require 'cases/helper'
require 'models/post'
require 'models/tagging'

module Namespaced
  class Post < ActiveRecord::Base
    set_table_name 'posts'
    has_one :tagging, :as => :taggable, :class_name => 'Tagging'
  end
end

class EagerLoadIncludeFullStiClassNamesTest < ActiveRecord::TestCase

  def setup
    generate_test_objects
  end

  def generate_test_objects
    post = Namespaced::Post.create( :title => 'Great stuff', :body => 'This is not', :author_id => 1 )
    tagging = Tagging.create( :taggable => post )
  end

  def test_class_names
    old = ActiveRecord::Base.store_full_sti_class

    ActiveRecord::Base.store_full_sti_class = false
    post = Namespaced::Post.find_by_title( 'Great stuff', :include => :tagging )
    assert_nil post.tagging

    ActiveRecord::Base.store_full_sti_class = true
    post = Namespaced::Post.find_by_title( 'Great stuff', :include => :tagging )
    assert_equal 'Tagging', post.tagging.class.name
  ensure
    ActiveRecord::Base.store_full_sti_class = old
  end
end
