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
  require 'action_controller'
rescue LoadError
  actionpack_path = "#{File.dirname(__FILE__)}/../../actionpack/lib"
  if File.directory?(actionpack_path)
    $:.unshift actionpack_path
    require 'action_controller'
  end
end

require 'action_view'

module ActionMailer
  def self.load_all!
    [Base, Part, ::Text::Format, ::Net::SMTP]
  end

  autoload :AdvAttrAccessor, 'action_mailer/adv_attr_accessor'
  autoload :Base, 'action_mailer/base'
  autoload :Helpers, 'action_mailer/helpers'
  autoload :Part, 'action_mailer/part'
  autoload :PartContainer, 'action_mailer/part_container'
  autoload :Quoting, 'action_mailer/quoting'
  autoload :TestCase, 'action_mailer/test_case'
  autoload :TestHelper, 'action_mailer/test_helper'
  autoload :Utils, 'action_mailer/utils'
end

module Text
  autoload :Format, 'action_mailer/vendor/text_format'
end

module Net
  autoload :SMTP, 'net/smtp'
end

autoload :MailHelper, 'action_mailer/mail_helper'

require 'action_mailer/vendor/tmail'
