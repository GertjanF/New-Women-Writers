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

min_release  = "1.8.2 (2004-12-25)"
ruby_release = "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE})"
if ruby_release =~ /1\.8\.3/
  abort <<-end_message

    Rails does not work with Ruby version 1.8.3.
    Please upgrade to version 1.8.4 or downgrade to 1.8.2.

  end_message
elsif ruby_release < min_release
  abort <<-end_message

    Rails requires Ruby version #{min_release} or later.
    You're running #{ruby_release}; please upgrade to continue.

  end_message
end
