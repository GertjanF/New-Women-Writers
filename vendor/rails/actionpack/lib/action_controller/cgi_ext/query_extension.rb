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

require 'cgi'

class CGI #:nodoc:
  module QueryExtension
    # Remove the old initialize_query method before redefining it.
    remove_method :initialize_query

    # Neuter CGI parameter parsing.
    def initialize_query
      # Fix some strange request environments.
      env_table['REQUEST_METHOD'] ||= 'GET'

      # POST assumes missing Content-Type is application/x-www-form-urlencoded.
      if env_table['CONTENT_TYPE'].blank? && env_table['REQUEST_METHOD'] == 'POST'
        env_table['CONTENT_TYPE'] = 'application/x-www-form-urlencoded'
      end

      @cookies = CGI::Cookie::parse(env_table['HTTP_COOKIE'] || env_table['COOKIE'])
      @params = {}
    end
  end
end
