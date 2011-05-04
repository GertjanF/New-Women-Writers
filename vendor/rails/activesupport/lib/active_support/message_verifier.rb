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
  # MessageVerifier makes it easy to generate and verify messages which are signed
  # to prevent tampering.
  # 
  # This is useful for cases like remember-me tokens and auto-unsubscribe links where the
  # session store isn't suitable or available.
  #
  # Remember Me:
  #   cookies[:remember_me] = @verifier.generate([@user.id, 2.weeks.from_now])
  # 
  # In the authentication filter:
  #
  #   id, time = @verifier.verify(cookies[:remember_me])
  #   if time < Time.now
  #     self.current_user = User.find(id)
  #   end
  # 
  class MessageVerifier
    class InvalidSignature < StandardError; end
    
    def initialize(secret, digest = 'SHA1')
      @secret = secret
      @digest = digest
    end
    
    def verify(signed_message)
      data, digest = signed_message.split("--")
      if secure_compare(digest, generate_digest(data))
        Marshal.load(ActiveSupport::Base64.decode64(data))
      else
        raise InvalidSignature
      end
    end
    
    def generate(value)
      data = ActiveSupport::Base64.encode64s(Marshal.dump(value))
      "#{data}--#{generate_digest(data)}"
    end
    
    private
      # constant-time comparison algorithm to prevent timing attacks
      def secure_compare(a, b)
        if a.length == b.length
          result = 0
          for i in 0..(a.length - 1)
            result |= a[i] ^ b[i]
          end
          result == 0
        else
          false
        end
      end

      def generate_digest(data)
        require 'openssl' unless defined?(OpenSSL)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new(@digest), @secret, data)
      end
  end
end
