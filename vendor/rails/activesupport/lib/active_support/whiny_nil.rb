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

# Extensions to +nil+ which allow for more helpful error messages for people who
# are new to Rails.
#
# Ruby raises NoMethodError if you invoke a method on an object that does not
# respond to it:
#
#   $ ruby -e nil.destroy
#   -e:1: undefined method `destroy' for nil:NilClass (NoMethodError)
#
# With these extensions, if the method belongs to the public interface of the
# classes in NilClass::WHINERS the error message suggests which could be the
# actual intended class:
#
#   $ script/runner nil.destroy 
#   ...
#   You might have expected an instance of ActiveRecord::Base.
#   ...
#
# NilClass#id exists in Ruby 1.8 (though it is deprecated). Since +id+ is a fundamental
# method of Active Record models NilClass#id is redefined as well to raise a RuntimeError
# and warn the user. She probably wanted a model database identifier and the 4
# returned by the original method could result in obscure bugs.
#
# The flag <tt>config.whiny_nils</tt> determines whether this feature is enabled.
# By default it is on in development and test modes, and it is off in production
# mode.
class NilClass
  WHINERS = [::Array]
  WHINERS << ::ActiveRecord::Base if defined? ::ActiveRecord

  METHOD_CLASS_MAP = Hash.new

  WHINERS.each do |klass|
    methods = klass.public_instance_methods - public_instance_methods
    class_name = klass.name
    methods.each { |method| METHOD_CLASS_MAP[method.to_sym] = class_name }
  end

  # Raises a RuntimeError when you attempt to call +id+ on +nil+.
  def id
    raise RuntimeError, "Called id for nil, which would mistakenly be 4 -- if you really wanted the id of nil, use object_id", caller
  end

  private
    def method_missing(method, *args, &block)
      raise_nil_warning_for METHOD_CLASS_MAP[method], method, caller
    end

    # Raises a NoMethodError when you attempt to call a method on +nil+.
    def raise_nil_warning_for(class_name = nil, selector = nil, with_caller = nil)
      message = "You have a nil object when you didn't expect it!"
      message << "\nYou might have expected an instance of #{class_name}." if class_name
      message << "\nThe error occurred while evaluating nil.#{selector}" if selector

      raise NoMethodError, message, with_caller || caller
    end
end

