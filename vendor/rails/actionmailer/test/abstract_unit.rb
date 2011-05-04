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

require 'rubygems'
require 'test/unit'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
$:.unshift "#{File.dirname(__FILE__)}/../../activesupport/lib"
$:.unshift "#{File.dirname(__FILE__)}/../../actionpack/lib"
require 'action_mailer'
require 'action_mailer/test_case'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true

# Bogus template processors
ActionView::Template.register_template_handler :haml, lambda { |template| "Look its HAML!".inspect }
ActionView::Template.register_template_handler :bak, lambda { |template| "Lame backup".inspect }

$:.unshift "#{File.dirname(__FILE__)}/fixtures/helpers"

ActionView::Base.cache_template_loading = true
FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
ActionMailer::Base.template_root = FIXTURE_LOAD_PATH

class MockSMTP
  def self.deliveries
    @@deliveries
  end

  def initialize
    @@deliveries = []
  end

  def sendmail(mail, from, to)
    @@deliveries << [mail, from, to]
  end

  def start(*args)
    yield self
  end
end

class Net::SMTP
  def self.new(*args)
    MockSMTP.new
  end
end

def uses_gem(gem_name, test_name, version = '> 0')
  gem gem_name.to_s, version
  require gem_name.to_s
  yield
rescue LoadError
  $stderr.puts "Skipping #{test_name} tests. `gem install #{gem_name}` and try again."
end

def set_delivery_method(delivery_method)
  @old_delivery_method = ActionMailer::Base.delivery_method
  ActionMailer::Base.delivery_method = delivery_method
end

def restore_delivery_method
  ActionMailer::Base.delivery_method = @old_delivery_method
end