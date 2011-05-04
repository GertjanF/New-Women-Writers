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

class Club < ActiveRecord::Base
  has_many :memberships
  has_many :members, :through => :memberships
  has_many :current_memberships
  has_one :sponsor
  has_one :sponsored_member, :through => :sponsor, :source => :sponsorable, :source_type => "Member"

  private

  def private_method
    "I'm sorry sir, this is a *private* club, not a *pirate* club"
  end
end