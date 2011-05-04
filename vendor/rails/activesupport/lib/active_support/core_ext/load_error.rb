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

class MissingSourceFile < LoadError #:nodoc:
  attr_reader :path
  def initialize(message, path)
    super(message)
    @path = path
  end

  def is_missing?(path)
    path.gsub(/\.rb$/, '') == self.path.gsub(/\.rb$/, '')
  end

  def self.from_message(message)
    REGEXPS.each do |regexp, capture|
      match = regexp.match(message)
      return MissingSourceFile.new(message, match[capture]) unless match.nil?
    end
    nil
  end

  REGEXPS = [
    [/^no such file to load -- (.+)$/i, 1],
    [/^Missing \w+ (file\s*)?([^\s]+.rb)$/i, 2],
    [/^Missing API definition file in (.+)$/i, 1]
  ] unless defined?(REGEXPS)
end

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module LoadErrorExtensions #:nodoc:
      module LoadErrorClassMethods #:nodoc:
        def new(*args)
          (self == LoadError && MissingSourceFile.from_message(args.first)) || super
        end
      end
      ::LoadError.extend(LoadErrorClassMethods)
    end
  end
end
