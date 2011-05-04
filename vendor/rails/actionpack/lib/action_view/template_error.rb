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

module ActionView
  # The TemplateError exception is raised when the compilation of the template fails. This exception then gathers a
  # bunch of intimate details and uses it to report a very precise exception message.
  class TemplateError < ActionViewError #:nodoc:
    SOURCE_CODE_RADIUS = 3

    attr_reader :original_exception

    def initialize(template, assigns, original_exception)
      @template, @assigns, @original_exception = template, assigns.dup, original_exception
      @backtrace = compute_backtrace
    end

    def file_name
      @template.relative_path
    end

    def message
      ActiveSupport::Deprecation.silence { original_exception.message }
    end

    def clean_backtrace
      if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner)
        Rails.backtrace_cleaner.clean(original_exception.backtrace)
      else
        original_exception.backtrace
      end
    end

    def sub_template_message
      if @sub_templates
        "Trace of template inclusion: " +
        @sub_templates.collect { |template| template.relative_path }.join(", ")
      else
        ""
      end
    end

    def source_extract(indentation = 0)
      return unless num = line_number
      num = num.to_i

      source_code = @template.source.split("\n")

      start_on_line = [ num - SOURCE_CODE_RADIUS - 1, 0 ].max
      end_on_line   = [ num + SOURCE_CODE_RADIUS - 1, source_code.length].min

      indent = ' ' * indentation
      line_counter = start_on_line
      return unless source_code = source_code[start_on_line..end_on_line]

      source_code.sum do |line|
        line_counter += 1
        "#{indent}#{line_counter}: #{line}\n"
      end
    end

    def sub_template_of(template_path)
      @sub_templates ||= []
      @sub_templates << template_path
    end

    def line_number
      @line_number ||=
        if file_name
          regexp = /#{Regexp.escape File.basename(file_name)}:(\d+)/

          $1 if message =~ regexp or clean_backtrace.find { |line| line =~ regexp }
        end
    end

    def to_s
      "\n#{self.class} (#{message}) #{source_location}:\n" + 
      "#{source_extract}\n    #{clean_backtrace.join("\n    ")}\n\n"
    end

    # don't do anything nontrivial here. Any raised exception from here becomes fatal 
    # (and can't be rescued).
    def backtrace
      @backtrace
    end

    private
      def compute_backtrace
        [
          "#{source_location.capitalize}\n\n#{source_extract(4)}\n    " +
          clean_backtrace.join("\n    ")
        ]
      end

      def source_location
        if line_number
          "on line ##{line_number} of "
        else
          'in '
        end + file_name
      end
  end
end