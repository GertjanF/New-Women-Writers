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

class Reception < ActiveRecord::Base
	#associations
	belongs_to :author
	belongs_to :country
	belongs_to :medium
	belongs_to :source
	belongs_to :work
	belongs_to :language
	has_many :reception_libs, :dependent => :delete_all
	has_many :reception_urls, :dependent => :delete_all
	has_many :libraries, :through => :reception_libs
  has_many :changes, :as => :object 
	
	# class methods
	#validates_presence_of :title

	def self.receptions
		find(:all, :order => "title")
	end
	
	def short_title
		title[0, 95]
	end

end
