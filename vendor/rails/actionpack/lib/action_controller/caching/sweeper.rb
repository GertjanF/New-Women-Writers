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

require 'active_record'

module ActionController #:nodoc:
  module Caching
    class Sweeper < ActiveRecord::Observer #:nodoc:
      attr_accessor :controller

      def before(controller)
        self.controller = controller
        callback(:before) if controller.perform_caching
      end

      def after(controller)
        callback(:after) if controller.perform_caching
        # Clean up, so that the controller can be collected after this request
        self.controller = nil
      end

      protected
        # gets the action cache path for the given options.
        def action_path_for(options)
          ActionController::Caching::Actions::ActionCachePath.path_for(controller, options)
        end

        # Retrieve instance variables set in the controller.
        def assigns(key)
          controller.instance_variable_get("@#{key}")
        end

      private
        def callback(timing)
          controller_callback_method_name = "#{timing}_#{controller.controller_name.underscore}"
          action_callback_method_name     = "#{controller_callback_method_name}_#{controller.action_name}"

          __send__(controller_callback_method_name) if respond_to?(controller_callback_method_name, true)
          __send__(action_callback_method_name)     if respond_to?(action_callback_method_name, true)
        end

        def method_missing(method, *arguments, &block)
          return if @controller.nil?
          @controller.__send__(method, *arguments, &block)
        end
    end
  end
end
