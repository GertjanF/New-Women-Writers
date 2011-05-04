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

require 'abstract_unit'

class Post
  def id
     45
  end
  def body
    "What a wonderful world!"
  end
end

class RecordTagHelperTest < ActionView::TestCase
  tests ActionView::Helpers::RecordTagHelper

  def setup
    @post = Post.new
  end

  def test_content_tag_for
    expected = %(<li class="post bar" id="post_45"></li>)
    actual = content_tag_for(:li, @post, :class => 'bar') { }
    assert_dom_equal expected, actual
  end

  def test_content_tag_for_prefix
    expected = %(<ul class="post" id="archived_post_45"></ul>)
    actual = content_tag_for(:ul, @post, :archived) { }
    assert_dom_equal expected, actual
  end

  def test_content_tag_for_with_extra_html_tags
    expected = %(<tr class="post bar" id="post_45" style='background-color: #f0f0f0'></tr>)
    actual = content_tag_for(:tr, @post, {:class => "bar", :style => "background-color: #f0f0f0"}) { }
    assert_dom_equal expected, actual
  end

  def test_block_not_in_erb_multiple_calls
    expected = %(<div class="post bar" id="post_45">#{@post.body}</div>)
    actual = div_for(@post, :class => "bar") { @post.body }
    assert_dom_equal expected, actual
    actual = div_for(@post, :class => "bar") { @post.body }
    assert_dom_equal expected, actual
  end

  def test_block_works_with_content_tag_for_in_erb
    __in_erb_template = ''
    expected = %(<tr class="post" id="post_45">#{@post.body}</tr>)
    actual = content_tag_for(:tr, @post) { concat @post.body }
    assert_dom_equal expected, actual
  end

  def test_div_for_in_erb
    __in_erb_template = ''
    expected = %(<div class="post bar" id="post_45">#{@post.body}</div>)
    actual = div_for(@post, :class => "bar") { concat @post.body }
    assert_dom_equal expected, actual
  end
end
