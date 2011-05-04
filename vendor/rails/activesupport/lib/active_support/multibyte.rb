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

# encoding: utf-8

module ActiveSupport #:nodoc:
  module Multibyte
    # A list of all available normalization forms. See http://www.unicode.org/reports/tr15/tr15-29.html for more
    # information about normalization.
    NORMALIZATION_FORMS = [:c, :kc, :d, :kd]

    # The Unicode version that is supported by the implementation
    UNICODE_VERSION = '5.1.0'

    # The default normalization used for operations that require normalization. It can be set to any of the
    # normalizations in NORMALIZATION_FORMS.
    #
    # Example:
    #   ActiveSupport::Multibyte.default_normalization_form = :c
    mattr_accessor :default_normalization_form
    self.default_normalization_form = :kc

    # The proxy class returned when calling mb_chars. You can use this accessor to configure your own proxy
    # class so you can support other encodings. See the ActiveSupport::Multibyte::Chars implementation for
    # an example how to do this.
    #
    # Example:
    #   ActiveSupport::Multibyte.proxy_class = CharsForUTF32
    def self.proxy_class=(klass)
      @proxy_class = klass
    end

    # Returns the currect proxy class
    def self.proxy_class
      @proxy_class ||= ActiveSupport::Multibyte::Chars
    end

    # Regular expressions that describe valid byte sequences for a character
    VALID_CHARACTER = {
      # Borrowed from the Kconv library by Shinji KONO - (also as seen on the W3C site)
      'UTF-8' => /\A(?:
                  [\x00-\x7f]                                         |
                  [\xc2-\xdf] [\x80-\xbf]                             |
                  \xe0        [\xa0-\xbf] [\x80-\xbf]                 |
                  [\xe1-\xef] [\x80-\xbf] [\x80-\xbf]                 |
                  \xf0        [\x90-\xbf] [\x80-\xbf] [\x80-\xbf]     |
                  [\xf1-\xf3] [\x80-\xbf] [\x80-\xbf] [\x80-\xbf]     |
                  \xf4        [\x80-\x8f] [\x80-\xbf] [\x80-\xbf])\z /xn,
      # Quick check for valid Shift-JIS characters, disregards the odd-even pairing
      'Shift_JIS' => /\A(?:
                  [\x00-\x7e \xa1-\xdf]                                     |
                  [\x81-\x9f \xe0-\xef] [\x40-\x7e \x80-\x9e \x9f-\xfc])\z /xn
    }
  end
end

require 'active_support/multibyte/chars'
require 'active_support/multibyte/exceptions'
require 'active_support/multibyte/unicode_database'
require 'active_support/multibyte/utils'
