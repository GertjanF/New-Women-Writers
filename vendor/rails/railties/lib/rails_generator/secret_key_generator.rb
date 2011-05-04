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

require 'active_support/deprecation'

module Rails
  # A class for creating random secret keys. This class will do its best to create a
  # random secret key that's as secure as possible, using whatever methods are
  # available on the current platform. For example:
  #
  #   generator = Rails::SecretKeyGenerator("some unique identifier, such as the application name")
  #   generator.generate_secret     # => "f3f1be90053fa851... (some long string)"
  #
  # This class is *deprecated* in Rails 2.2 in favor of ActiveSupport::SecureRandom.
  # It is currently a wrapper around ActiveSupport::SecureRandom.
  class SecretKeyGenerator
    def initialize(identifier)
    end

    # Generate a random secret key with the best possible method available on
    # the current platform.
    def generate_secret
      ActiveSupport::SecureRandom.hex(64)
    end
    deprecate :generate_secret=>"You should use ActiveSupport::SecureRandom.hex(64)"
  end
end
