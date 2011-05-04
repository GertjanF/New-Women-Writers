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

class Comment < ActiveRecord::Base
  attr_accessor :callers

  before_validation :record_callers

  def after_validation
    record_callers
  end

  def record_callers
    callers << self.class if callers
  end
end

class CommentObserver < ActiveRecord::Observer
  attr_accessor :callers

  def after_validation(model)
    callers << self.class if callers
  end
end

class CallbacksObserversTest < ActiveRecord::TestCase
  def test_model_callbacks_fire_before_observers_are_notified
    callers = []

    comment = Comment.new
    comment.callers = callers

    CommentObserver.instance.callers = callers

    comment.valid?

    assert_equal [Comment, Comment, CommentObserver], callers, "model callbacks did not fire before observers were notified"
  end
end
