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
  create_table :binary_fields, :force => true, :options => 'CHARACTER SET latin1' do |t|
    t.binary :tiny_blob,   :limit => 255
    t.binary :normal_blob, :limit => 65535
    t.binary :medium_blob, :limit => 16777215
    t.binary :long_blob,   :limit => 2147483647
    t.text   :tiny_text,   :limit => 255
    t.text   :normal_text, :limit => 65535
    t.text   :medium_text, :limit => 16777215
    t.text   :long_text,   :limit => 2147483647
  end
end
