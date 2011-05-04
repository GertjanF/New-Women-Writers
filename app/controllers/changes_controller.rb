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

class ChangesController < ApplicationController
before_filter :editor_required
before_filter :find_changes, :except => [:index, :new, :create, :approve]

  def approve
	@approved_changes = Change.find(:all, :conditions =>{ :object_name => params[:object_name], :object_id => params[:object_id]})
	@approved_changes.each do |change|
		change.update_attribute(:approved, 1)
	end
	redirect_to :controller => params[:object_name], :action => 'show', :id => params[:object_id]
  end
  
  def create
  end

  def destroy
  end

  def edit
  end

	def index
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 then params[:per_page]=20 end
		if !params[:search_name] .nil? then searched_name = '%'+params[:search_name]+'%' else searched_name='%' end
		if params[:sort] .nil? then  params[:sort]="changes.created_at DESC" end
		
		condition_var="users.name iLIKE ? " 
		
		@pagin = Change.find(:all, :conditions => [condition_var, searched_name], :include => 'user')
		@help_paginate = @pagin.length
		if @help_paginate.to_i <= (params[:per_page].to_i * (params[:page].to_i - 1)) then params[:page] = 1 end

		@changes = Change.paginate  :per_page => params[:per_page],
														:include => 'user',
														:order => params[:sort],
														:page => params[:page],
														:conditions => [condition_var, searched_name]
		@count=@changes.total_entries

		if request.xml_http_request?						
			render :partial => "changelist" 
		end
	end

  def new
  end

  def show
  end

  def update
  end
  
  private
	def find_changes
		@change = Change.find(params[:id])
	end
	

end
