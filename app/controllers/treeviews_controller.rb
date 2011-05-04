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

class TreeviewsController < ApplicationController
	before_filter :find_author, :only => [:show]

	def index
	end
	
	def show

	@is_read_by = Reception.find_by_sql ["SELECT DISTINCT authors.id as id, authors.name as name
		FROM receptions 
		INNER JOIN works ON receptions.work_id=works.id
		INNER JOIN AUTHORS ON receptions.author_id=authors.id
		WHERE works.author_id= ?
		ORDER BY authors.name", params[:id]]
		
	@first_is_read_by_id=@is_read_by.first.id unless @is_read_by.empty?
	@last_is_read_by_id=@is_read_by.last.id unless @is_read_by.empty?

	@has_read = Reception.find_by_sql ["SELECT DISTINCT authors.id as id, authors.name as name
			FROM receptions
			INNER JOIN works ON receptions.work_id=works.id
			INNER JOIN AUTHORS ON works.author_id=authors.id
			WHERE receptions.author_id= ?
			ORDER BY authors.name", params[:id]]
			
	@first_has_read_id=@has_read.first.id unless @has_read.empty?
	@last_has_read_id=@has_read.last.id unless @has_read.empty?
			
	end

	private 
	
	def find_author
		@author = Author.find(params[:id])
	end
end

