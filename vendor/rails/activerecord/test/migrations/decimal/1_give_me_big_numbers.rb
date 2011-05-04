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

class GiveMeBigNumbers < ActiveRecord::Migration
  def self.up
    create_table :big_numbers do |table|
      table.column :bank_balance, :decimal, :precision => 10, :scale => 2
      table.column :big_bank_balance, :decimal, :precision => 15, :scale => 2
      table.column :world_population, :decimal, :precision => 10
      table.column :my_house_population, :decimal, :precision => 2
      table.column :value_of_e, :decimal
    end
  end

  def self.down
    drop_table :big_numbers
  end
end
