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

module I18n
  class ArgumentError < ::ArgumentError; end

  class InvalidLocale < ArgumentError
    attr_reader :locale
    def initialize(locale)
      @locale = locale
      super "#{locale.inspect} is not a valid locale"
    end
  end

  class MissingTranslationData < ArgumentError
    attr_reader :locale, :key, :options
    def initialize(locale, key, options)
      @key, @locale, @options = key, locale, options
      keys = I18n.send(:normalize_translation_keys, locale, key, options[:scope])
      keys << 'no key' if keys.size < 2
      super "translation missing: #{keys.join(', ')}"
    end
  end

  class InvalidPluralizationData < ArgumentError
    attr_reader :entry, :count
    def initialize(entry, count)
      @entry, @count = entry, count
      super "translation data #{entry.inspect} can not be used with :count => #{count}"
    end
  end

  class MissingInterpolationArgument < ArgumentError
    attr_reader :key, :string
    def initialize(key, string)
      @key, @string = key, string
      super "interpolation argument #{key} missing in #{string.inspect}"
    end
  end

  class ReservedInterpolationKey < ArgumentError
    attr_reader :key, :string
    def initialize(key, string)
      @key, @string = key, string
      super "reserved key #{key.inspect} used in #{string.inspect}"
    end
  end

  class UnknownFileType < ArgumentError
    attr_reader :type, :filename
    def initialize(type, filename)
      @type, @filename = type, filename
      super "can not load translations from #{filename}, the file type #{type} is not known"
    end
  end
end