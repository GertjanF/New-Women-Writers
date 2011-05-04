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

class Work < ActiveRecord::Base
	#associations
	belongs_to :author
	belongs_to :language
	belongs_to :country
	has_many :prints, :dependent => :delete_all
	has_many :receptions, :dependent => :destroy
	has_many :work_libs, :dependent => :delete_all
	has_many :work_urls, :dependent => :delete_all
	has_many :libraries,  :through => :work_libs
  has_many :changes, :as => :object 
	has_and_belongs_to_many :genres
	has_and_belongs_to_many :topois

	# class methods
	validates_presence_of :title

	def self.works
		find(:all, :order => "title")
	end
		
	def work_author
		title + " - by " + author.name
	end
	
	def short_title
		title[0, 95]
	end
	
end
