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

class Object
  # Returns +value+ after yielding +value+ to the block. This simplifies the
  # process of constructing an object, performing work on the object, and then
  # returning the object from a method. It is a Ruby-ized realization of the K
  # combinator, courtesy of Mikael Brockman.
  #
  # ==== Examples
  #
  #  # Without returning
  #  def foo
  #    values = []
  #    values << "bar"
  #    values << "baz"
  #    return values
  #  end
  #
  #  foo # => ['bar', 'baz']
  #
  #  # returning with a local variable
  #  def foo
  #    returning values = [] do
  #      values << 'bar'
  #      values << 'baz'
  #    end
  #  end
  #
  #  foo # => ['bar', 'baz']
  #  
  #  # returning with a block argument
  #  def foo
  #    returning [] do |values|
  #      values << 'bar'
  #      values << 'baz'
  #    end
  #  end
  #  
  #  foo # => ['bar', 'baz']
  def returning(value)
    yield(value)
    value
  end

  # Yields <code>x</code> to the block, and then returns <code>x</code>.
  # The primary purpose of this method is to "tap into" a method chain,
  # in order to perform operations on intermediate results within the chain.
  #
  #   (1..10).tap { |x| puts "original: #{x.inspect}" }.to_a.
  #     tap    { |x| puts "array: #{x.inspect}" }.
  #     select { |x| x%2 == 0 }.
  #     tap    { |x| puts "evens: #{x.inspect}" }.
  #     map    { |x| x*x }.
  #     tap    { |x| puts "squares: #{x.inspect}" }
  def tap
    yield self
    self
  end unless Object.respond_to?(:tap)

  # An elegant way to factor duplication out of options passed to a series of
  # method calls. Each method called in the block, with the block variable as
  # the receiver, will have its options merged with the default +options+ hash
  # provided. Each method called on the block variable must take an options
  # hash as its final argument.
  # 
  #   with_options :order => 'created_at', :class_name => 'Comment' do |post|
  #     post.has_many :comments, :conditions => ['approved = ?', true], :dependent => :delete_all
  #     post.has_many :unapproved_comments, :conditions => ['approved = ?', false]
  #     post.has_many :all_comments
  #   end
  #
  # Can also be used with an explicit receiver:
  #
  #   map.with_options :controller => "people" do |people|
  #     people.connect "/people",     :action => "index"
  #     people.connect "/people/:id", :action => "show"
  #   end
  #
  def with_options(options)
    yield ActiveSupport::OptionMerger.new(self, options)
  end
  
  # A duck-type assistant method. For example, Active Support extends Date
  # to define an acts_like_date? method, and extends Time to define
  # acts_like_time?. As a result, we can do "x.acts_like?(:time)" and
  # "x.acts_like?(:date)" to do duck-type-safe comparisons, since classes that
  # we want to act like Time simply need to define an acts_like_time? method.
  def acts_like?(duck)
    respond_to? "acts_like_#{duck}?"
  end

end
