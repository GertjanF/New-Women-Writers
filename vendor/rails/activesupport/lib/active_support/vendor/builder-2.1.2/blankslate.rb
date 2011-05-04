#!/usr/bin/env ruby
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

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#++

######################################################################
# BlankSlate provides an abstract base class with no predefined
# methods (except for <tt>\_\_send__</tt> and <tt>\_\_id__</tt>).
# BlankSlate is useful as a base class when writing classes that
# depend upon <tt>method_missing</tt> (e.g. dynamic proxies).
#
class BlankSlate
  class << self

    # Hide the method named +name+ in the BlankSlate class.  Don't
    # hide +instance_eval+ or any method beginning with "__".
    def hide(name)
      if instance_methods.include?(name.to_s) and
        name !~ /^(__|instance_eval)/
        @hidden_methods ||= {}
        @hidden_methods[name.to_sym] = instance_method(name)
        undef_method name
      end
    end

    def find_hidden_method(name)
      @hidden_methods ||= {}
      @hidden_methods[name] || superclass.find_hidden_method(name)
    end

    # Redefine a previously hidden method so that it may be called on a blank
    # slate object.
    def reveal(name)
      bound_method = nil
      unbound_method = find_hidden_method(name)
      fail "Don't know how to reveal method '#{name}'" unless unbound_method
      define_method(name) do |*args|
        bound_method ||= unbound_method.bind(self)
        bound_method.call(*args)
      end
    end
  end

  instance_methods.each { |m| hide(m) }
end

######################################################################
# Since Ruby is very dynamic, methods added to the ancestors of
# BlankSlate <em>after BlankSlate is defined</em> will show up in the
# list of available BlankSlate methods.  We handle this by defining a
# hook in the Object and Kernel classes that will hide any method
# defined after BlankSlate has been loaded.
#
module Kernel
  class << self
    alias_method :blank_slate_method_added, :method_added

    # Detect method additions to Kernel and remove them in the
    # BlankSlate class.
    def method_added(name)
      result = blank_slate_method_added(name)
      return result if self != Kernel
      BlankSlate.hide(name)
      result
    end
  end
end

######################################################################
# Same as above, except in Object.
#
class Object
  class << self
    alias_method :blank_slate_method_added, :method_added

    # Detect method additions to Object and remove them in the
    # BlankSlate class.
    def method_added(name)
      result = blank_slate_method_added(name)
      return result if self != Object
      BlankSlate.hide(name)
      result
    end

    def find_hidden_method(name)
      nil
    end
  end
end

######################################################################
# Also, modules included into Object need to be scanned and have their
# instance methods removed from blank slate.  In theory, modules
# included into Kernel would have to be removed as well, but a
# "feature" of Ruby prevents late includes into modules from being
# exposed in the first place.
#
class Module
  alias blankslate_original_append_features append_features
  def append_features(mod)
    result = blankslate_original_append_features(mod)
    return result if mod != Object
    instance_methods.each do |name|
      BlankSlate.hide(name)
    end
    result
  end
end