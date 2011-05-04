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

begin
  require_library_or_gem 'memcache'

  module ActionController
    module Session
      class MemCacheStore < AbstractStore
        def initialize(app, options = {})
          # Support old :expires option
          options[:expire_after] ||= options[:expires]

          super

          @default_options = {
            :namespace => 'rack:session',
            :memcache_server => 'localhost:11211'
          }.merge(@default_options)

          @pool = options[:cache] || MemCache.new(@default_options[:memcache_server], @default_options)
          unless @pool.servers.any? { |s| s.alive? }
            raise "#{self} unable to find server during initialization."
          end
          @mutex = Mutex.new

          super
        end

        private
          def get_session(env, sid)
            sid ||= generate_sid
            begin
              session = @pool.get(sid) || {}
            rescue MemCache::MemCacheError, Errno::ECONNREFUSED
              session = {}
            end
            [sid, session]
          end

          def set_session(env, sid, session_data)
            options = env['rack.session.options']
            expiry  = options[:expire_after] || 0
            @pool.set(sid, session_data, expiry)
            return true
          rescue MemCache::MemCacheError, Errno::ECONNREFUSED
            return false
          end
      end
    end
  end
rescue LoadError
  # MemCache wasn't available so neither can the store be
end
