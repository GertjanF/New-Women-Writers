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

module ActiveResource
  class ConnectionError < StandardError # :nodoc:
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      "Failed with #{response.code} #{response.message if response.respond_to?(:message)}"
    end
  end

  # Raised when a Timeout::Error occurs.
  class TimeoutError < ConnectionError
    def initialize(message)
      @message = message
    end
    def to_s; @message ;end
  end

  # Raised when a OpenSSL::SSL::SSLError occurs.
  class SSLError < ConnectionError
    def initialize(message)
      @message = message
    end
    def to_s; @message ;end
  end

  # 3xx Redirection
  class Redirection < ConnectionError # :nodoc:
    def to_s; response['Location'] ? "#{super} => #{response['Location']}" : super; end
  end

  # 4xx Client Error
  class ClientError < ConnectionError; end # :nodoc:

  # 400 Bad Request
  class BadRequest < ClientError; end # :nodoc

  # 401 Unauthorized
  class UnauthorizedAccess < ClientError; end # :nodoc

  # 403 Forbidden
  class ForbiddenAccess < ClientError; end # :nodoc

  # 404 Not Found
  class ResourceNotFound < ClientError; end # :nodoc:

  # 409 Conflict
  class ResourceConflict < ClientError; end # :nodoc:

  # 410 Gone
  class ResourceGone < ClientError; end # :nodoc:

  # 5xx Server Error
  class ServerError < ConnectionError; end # :nodoc:

  # 405 Method Not Allowed
  class MethodNotAllowed < ClientError # :nodoc:
    def allowed_methods
      @response['Allow'].split(',').map { |verb| verb.strip.downcase.to_sym }
    end
  end
end
