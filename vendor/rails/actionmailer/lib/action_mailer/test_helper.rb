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

module ActionMailer
  module TestHelper
    # Asserts that the number of emails sent matches the given number.
    #
    #   def test_emails
    #     assert_emails 0
    #     ContactMailer.deliver_contact
    #     assert_emails 1
    #     ContactMailer.deliver_contact
    #     assert_emails 2
    #   end
    #
    # If a block is passed, that block should cause the specified number of emails to be sent.
    #
    #   def test_emails_again
    #     assert_emails 1 do
    #       ContactMailer.deliver_contact
    #     end
    #
    #     assert_emails 2 do
    #       ContactMailer.deliver_contact
    #       ContactMailer.deliver_contact
    #     end
    #   end
    def assert_emails(number)
      if block_given?
        original_count = ActionMailer::Base.deliveries.size
        yield
        new_count = ActionMailer::Base.deliveries.size
        assert_equal original_count + number, new_count, "#{number} emails expected, but #{new_count - original_count} were sent"
      else
        assert_equal number, ActionMailer::Base.deliveries.size
      end
    end

    # Assert that no emails have been sent.
    #
    #   def test_emails
    #     assert_no_emails
    #     ContactMailer.deliver_contact
    #     assert_emails 1
    #   end
    #
    # If a block is passed, that block should not cause any emails to be sent.
    #
    #   def test_emails_again
    #     assert_no_emails do
    #       # No emails should be sent from this block
    #     end
    #   end
    #
    # Note: This assertion is simply a shortcut for:
    #
    #   assert_emails 0
    def assert_no_emails(&block)
      assert_emails 0, &block
    end
  end
end

# TODO: Deprecate this
module Test
  module Unit
    class TestCase
      include ActionMailer::TestHelper
    end
  end
end
