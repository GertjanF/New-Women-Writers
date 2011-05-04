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

class WorkUrlsController < ApplicationController
before_filter :editor_required, :except => [:index, :show]
before_filter :find_work_url, :except => [:index, :new, :create]

	def create
		@work_url = WorkUrl.new(params[:work_url])
		if @work_url.save
			log_change('create', 1, @work_url)
			flash[:notice]= 'Link successfully created.'
			redirect_to :action => "index"
		else
			render :action => "new"
		end
	end

	def destroy
		@work_url.destroy
    log_change('delete', 1, @work_url)
    redirect_to :action => "index"
	end

	def index
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 then params[:per_page]=20 end
		if !params[:search_name] .nil? then searched_name = '%'+params[:search_name]+'%' else searched_name='%' end
		if params[:sort] .nil? then  params[:sort]="upper(works.title)" end

		@pagin = WorkUrl.find(:all, :conditions => ["works.title iLIKE ?", searched_name], :include => 'work')
		@help_paginate = @pagin.length
		if @help_paginate.to_i <= (params[:per_page].to_i * (params[:page].to_i - 1)) then params[:page] = 1 end
		
		@work_urls = WorkUrl.paginate  :per_page => params[:per_page],
															:include => 'work',
															:order => params[:sort],
															:page => params[:page],
															:conditions => ["works.title iLIKE ?", searched_name]
		@count=@work_urls.total_entries

		if request.xml_http_request?						
			render :partial => "work_urllist" 
		end
	end
  
	def new
		@work_url = WorkUrl.new
	end

	def update
		if @work_url.update_attributes(params[:work_url])
			log_change('update', 1, @work_url)
			flash[:notice] = 'Link successfully updated.'
			redirect_to :action => "show", :id => params[:id]
		else
			render :action => "edit"
		end
	end
	
	private
	def find_work_url
		@work_url = WorkUrl.find(params[:id])
	end
	
end
