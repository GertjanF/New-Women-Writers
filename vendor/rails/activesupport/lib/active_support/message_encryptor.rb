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

require 'openssl'

module ActiveSupport
  # MessageEncryptor is a simple way to encrypt values which get stored somewhere 
  # you don't trust.
  # 
  # The cipher text and initialization vector are base64 encoded and returned to you.
  #
  # This can be used in situations similar to the MessageVerifier, but where you don't
  # want users to be able to determine the value of the payload.
  class MessageEncryptor
    class InvalidMessage < StandardError; end
    OpenSSLCipherError = OpenSSL::Cipher.const_defined?(:CipherError) ? OpenSSL::Cipher::CipherError : OpenSSL::CipherError

    def initialize(secret, cipher = 'aes-256-cbc')
      @secret = secret
      @cipher = cipher
    end
    
    def encrypt(value)
      cipher = new_cipher
      # Rely on OpenSSL for the initialization vector
      iv = cipher.random_iv
      
      cipher.encrypt 
      cipher.key = @secret
      cipher.iv  = iv
      
      encrypted_data = cipher.update(Marshal.dump(value)) 
      encrypted_data << cipher.final

      [encrypted_data, iv].map {|v| ActiveSupport::Base64.encode64s(v)}.join("--")
    end
    
    def decrypt(encrypted_message)
      cipher = new_cipher
      encrypted_data, iv = encrypted_message.split("--").map {|v| ActiveSupport::Base64.decode64(v)}
      
      cipher.decrypt
      cipher.key = @secret
      cipher.iv  = iv

      decrypted_data = cipher.update(encrypted_data)
      decrypted_data << cipher.final
      
      Marshal.load(decrypted_data)
    rescue OpenSSLCipherError, TypeError
      raise InvalidMessage
    end
    
    def encrypt_and_sign(value)
      verifier.generate(encrypt(value))
    end
    
    def decrypt_and_verify(value)
      decrypt(verifier.verify(value))
    end
    
    
    
    private 
      def new_cipher
        OpenSSL::Cipher::Cipher.new(@cipher)
      end
      
      def verifier
        MessageVerifier.new(@secret)
      end
  end
end
