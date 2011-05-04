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

# class TranslatingController < ActionController::Base
# end

class TranslationControllerTest < Test::Unit::TestCase
  def setup
    @controller = ActionController::Base.new
  end
  
  def test_action_controller_base_responds_to_translate
    assert @controller.respond_to?(:translate)
  end
  
  def test_action_controller_base_responds_to_t
    assert @controller.respond_to?(:t)
  end
  
  def test_action_controller_base_responds_to_localize
    assert @controller.respond_to?(:localize)
  end
  
  def test_action_controller_base_responds_to_l
    assert @controller.respond_to?(:l)
  end
end