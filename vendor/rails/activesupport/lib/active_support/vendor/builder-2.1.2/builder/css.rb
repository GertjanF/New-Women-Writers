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

# Provide a flexible and easy to use Builder for creating Cascading
# Style Sheets (CSS).


require 'builder/blankslate'

module Builder

  # Create a Cascading Style Sheet (CSS) using Ruby.
  #
  # Example usage:
  #
  #   css = Builder::CSS.new
  #
  #   text_color      = '#7F7F7F'
  #   preferred_fonts = 'Helvetica, Arial, sans_serif'
  #
  #   css.comment! 'This is our stylesheet'
  #   css.body {
  #     background_color '#FAFAFA'
  #     font_size        'small'
  #     font_family      preferred_fonts
  #     color            text_color
  #   }
  #
  #   css.id!('navbar') {
  #     width            '500px'
  #   }
  #
  #   css.class!('navitem') {
  #     color            'red'
  #   }
  #
  #   css.a :hover {
  #     text_decoration  'underline'
  #   }
  #
  #   css.div(:id => 'menu') {
  #     background       'green'
  #   }
  #
  #   css.div(:class => 'foo') {
  #     background       'red'
  #   }
  #
  # This will yield the following stylesheet:
  #
  #   /* This is our stylesheet */
  #   body {
  #     background_color: #FAFAFA;
  #     font_size:        small;
  #     font_family:      Helvetica, Arial, sans_serif;
  #     color:            #7F7F7F;
  #   }
  #
  #   #navbar {
  #     width:            500px;
  #   }
  #
  #   .navitem {
  #     color:            red;
  #   }
  #
  #   a:hover {
  #     text_decoration:  underline;
  #   }
  #
  #   div#menu {
  #     background:       green;
  #   }
  #
  #   div.foo {
  #     background:       red;
  #   }
  #
  class CSS < BlankSlate

    # Create a CSS builder.
    #
    # out::     Object receiving the markup.1  +out+ must respond to
    #           <tt><<</tt>.
    # indent::  Number of spaces used for indentation (0 implies no
    #           indentation and no line breaks).
    #
    def initialize(indent=2)
      @indent      = indent
      @target      = []
      @parts       = []
      @library     = {}
    end

    def +(part)
      _join_with_op! '+'
      self
    end

    def >>(part)
      _join_with_op! ''
      self
    end

    def >(part)
      _join_with_op! '>'
      self
    end

    def |(part)
      _join_with_op! ','
      self
    end

    # Return the target of the builder
    def target!
      @target * ''
    end

    # Create a comment string in the output.
    def comment!(comment_text)
      @target << "/* #{comment_text} */\n"
    end

    def id!(arg, &block)
      _start_container('#'+arg.to_s, nil, block_given?)
      _css_block(block) if block
      _unify_block
      self
    end

    def class!(arg, &block)
      _start_container('.'+arg.to_s, nil, block_given?)
      _css_block(block) if block
      _unify_block
      self
    end

    def store!(sym, &block)
      @library[sym] = block.to_proc
    end

    def group!(*args, &block)
      args.each do |arg|
        if arg.is_a?(Symbol)
          instance_eval(&@library[arg])
        else
          instance_eval(&arg)
        end
        _text ', ' unless arg == args.last
      end
      if block
        _css_block(block)
        _unify_block
      end
    end

    def method_missing(sym, *args, &block)
      sym = "#{sym}:#{args.shift}" if args.first.kind_of?(Symbol)
      if block
        _start_container(sym, args.first)
        _css_block(block)
        _unify_block
      elsif @in_block
        _indent
        _css_line(sym, *args)
        _newline
        return self
      else
        _start_container(sym, args.first, false)
        _unify_block
      end
      self
    end

    # "Cargo culted" from Jim who also "cargo culted" it.  See xmlbase.rb.
    def nil?
      false
    end

    private
    def _unify_block
      @target << @parts * ''
      @parts = []
    end

    def _join_with_op!(op)
      rhs, lhs = @target.pop, @target.pop
      @target << "#{lhs} #{op} #{rhs}"
    end

    def _text(text)
      @parts << text
    end

    def _css_block(block)
      _newline
      _nested_structures(block)
      _end_container
      _end_block
    end

    def _end_block
      _newline
      _newline
    end

    def _newline
      _text "\n"
    end

    def _indent
      _text ' ' * @indent
    end

    def _nested_structures(block)
      @in_block = true
      self.instance_eval(&block)
      @in_block = false
    end

    def _start_container(sym, atts = {}, with_bracket = true)
      selector = sym.to_s
      selector << ".#{atts[:class]}" if atts && atts[:class]
      selector << '#' + "#{atts[:id]}" if atts && atts[:id]
      @parts << "#{selector}#{with_bracket ? ' {' : ''}"
    end

    def _end_container
      @parts << "}"
    end

    def _css_line(sym, *args)
      _text("#{sym.to_s.gsub('_','-')}: #{args * ' '};")
    end
  end
end
