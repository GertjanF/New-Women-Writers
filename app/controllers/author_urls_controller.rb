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

class AuthorUrlsController < ApplicationController
before_filter :editor_required, :except => [:index, :show]
before_filter :find_author_url, :except => [:index, :new, :create, :search, :result]
 
	def create
		@author_url = AuthorUrl.new(params[:author_url])
		if @author_url.save
			log_change('create', 1, @author_url)
			flash[:notice]= 'Link successfully created.'
			redirect_to :action => "index"
		else
			render :action => "new"
		end
	end
	
	def destroy
		@author_url.destroy
    log_change('delete', 1, @author_url)
    redirect_to :action => "index"
	end

	def index
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 then params[:per_page]=20 end
		if !params[:search_name] .nil? then searched_name = '%'+params[:search_name]+'%' else searched_name='%' end
		if params[:sort] .nil? then  params[:sort]="upper(authors.name)" end
		
		@pagin = AuthorUrl.find(:all, :conditions => ["authors.name iLIKE ?", searched_name], :include => 'author')
		@help_paginate = @pagin.length
		if @help_paginate.to_i <= (params[:per_page].to_i * (params[:page].to_i - 1)) then params[:page] = 1 end

		@author_urls = AuthorUrl.paginate  	:per_page => params[:per_page],
															:include => 'author',
															:order => params[:sort],
															:page => params[:page],
															:conditions => ["authors.name iLIKE ?", searched_name]
		@count=@author_urls.total_entries

		if request.xml_http_request?						
			render :partial => "author_urllist" 
		end
	end

  
	def new
		@author_url = AuthorUrl.new
	end
	
	def result
		unless params['search_title'].empty?
			searched_title = params['search_title']+'%'
			@result = AuthorUrl.find(:all, :conditions => ["title ilike ?", searched_title])
		else
			@result = AuthorUrl.all
		end
		#render :partial => "result", :collection => @result
	end

	def update
		if @author_url.update_attributes(params[:author_url])
			log_change('update', 1, @author_url)
			flash[:notice] = 'Link successfully updated.'
			redirect_to :action => "show", :id => params[:id]
		else
			render :action => "edit"
		end
	end
	
	private
	def find_author_url
		@author_url = AuthorUrl.find(params[:id])
	end
	
end
