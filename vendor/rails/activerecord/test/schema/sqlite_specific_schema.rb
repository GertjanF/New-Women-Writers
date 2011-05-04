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

ActiveRecord::Schema.define do
  # For sqlite 3.1.0+, make a table with a autoincrement column
  if supports_autoincrement?
    create_table :table_with_autoincrement, :force => true do |t|
      t.column :name, :string
    end
  end

  execute "DROP TABLE fk_test_has_fk" rescue nil
  execute "DROP TABLE fk_test_has_pk" rescue nil
  execute <<_SQL
  CREATE TABLE 'fk_test_has_pk' (
    'id' INTEGER NOT NULL PRIMARY KEY
  );
_SQL

  execute <<_SQL
  CREATE TABLE 'fk_test_has_fk' (
    'id'    INTEGER NOT NULL PRIMARY KEY,
    'fk_id' INTEGER NOT NULL,

    FOREIGN KEY ('fk_id') REFERENCES 'fk_test_has_pk'('id')
  );
_SQL
end