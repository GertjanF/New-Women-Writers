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

class Contact < ActiveRecord::Base
  # mock out self.columns so no pesky db is needed for these tests
  def self.column(name, sql_type = nil, options = {})
    @columns ||= []
    @columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, options[:default], sql_type.to_s, options[:null])
  end

  column :name,        :string
  column :age,         :integer
  column :avatar,      :binary
  column :created_at,  :datetime
  column :awesome,     :boolean
  column :preferences, :string

  serialize :preferences
end