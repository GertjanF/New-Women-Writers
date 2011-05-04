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

module ActiveSupport
  # Many backtraces include too much information that's not relevant for the context. This makes it hard to find the signal
  # in the backtrace and adds debugging time. With a BacktraceCleaner, you can setup filters and silencers for your particular
  # context, so only the relevant lines are included.
  #
  # If you need to reconfigure an existing BacktraceCleaner, like the one in Rails, to show as much as possible, you can always
  # call BacktraceCleaner#remove_silencers!
  #
  # Example:
  #
  #   bc = BacktraceCleaner.new
  #   bc.add_filter   { |line| line.gsub(Rails.root, '') } 
  #   bc.add_silencer { |line| line =~ /mongrel|rubygems/ }
  #   bc.clean(exception.backtrace) # will strip the Rails.root prefix and skip any lines from mongrel or rubygems
  #
  # Inspired by the Quiet Backtrace gem by Thoughtbot.
  class BacktraceCleaner
    def initialize
      @filters, @silencers = [], []
    end
    
    # Returns the backtrace after all filters and silencers has been run against it. Filters run first, then silencers.
    def clean(backtrace)
      silence(filter(backtrace))
    end

    # Adds a filter from the block provided. Each line in the backtrace will be mapped against this filter.
    #
    # Example:
    #
    #   # Will turn "/my/rails/root/app/models/person.rb" into "/app/models/person.rb"
    #   backtrace_cleaner.add_filter { |line| line.gsub(Rails.root, '') }
    def add_filter(&block)
      @filters << block
    end

    # Adds a silencer from the block provided. If the silencer returns true for a given line, it'll be excluded from the
    # clean backtrace.
    #
    # Example:
    #
    #   # Will reject all lines that include the word "mongrel", like "/gems/mongrel/server.rb" or "/app/my_mongrel_server/rb"
    #   backtrace_cleaner.add_silencer { |line| line =~ /mongrel/ }
    def add_silencer(&block)
      @silencers << block
    end

    # Will remove all silencers, but leave in the filters. This is useful if your context of debugging suddenly expands as
    # you suspect a bug in the libraries you use.
    def remove_silencers!
      @silencers = []
    end

    
    private
      def filter(backtrace)
        @filters.each do |f|
          backtrace = backtrace.map { |line| f.call(line) }
        end
        
        backtrace
      end
      
      def silence(backtrace)
        @silencers.each do |s|
          backtrace = backtrace.reject { |line| s.call(line) }
        end
        
        backtrace
      end
  end
end
