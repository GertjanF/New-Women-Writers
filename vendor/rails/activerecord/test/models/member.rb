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

class Member < ActiveRecord::Base
  has_one :current_membership
  has_many :memberships
  has_many :fellow_members, :through => :club, :source => :members
  has_one :club, :through => :current_membership
  has_one :favourite_club, :through => :memberships, :conditions => ["memberships.favourite = ?", true], :source => :club
  has_one :sponsor, :as => :sponsorable
  has_one :sponsor_club, :through => :sponsor
  has_one :member_detail
  has_one :organization, :through => :member_detail
  belongs_to :member_type
end