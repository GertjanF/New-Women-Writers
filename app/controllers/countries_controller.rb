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

class CountriesController < ApplicationController
before_filter :editor_required, :except => [:index, :show]
before_filter :find_country, :except => [:index, :new, :create]
 
	def create
		@country = Country.new(params[:country])
		if params[:backtoauthor]=='country'
			if @country.save
				log_change('create', 1, @country)
				flash[:notice] = 'Country successfully created.'
				redirect_to :controller => 'authors', :action => "edit", :id => params[:author_id]
			else
				render :action => "new"
			end
		elsif params[:backtoreception]=='country'
				if @country.save
					log_change('create', 1, @country)
					flash[:notice] = 'Country successfully created.'
					redirect_to :controller => 'receptions', :action => "edit", :id => params[:reception_id]
				else
					render :action => "new"
				end
		elsif params[:backtowork]=='country'
				if @country.save
					log_change('create', 1, @country)
					flash[:notice] = 'Country successfully created.'
					redirect_to :controller => 'works', :action => "edit", :id => params[:work_id]
				else
					render :action => "new"
				end
		else
			if @country.save
				log_change('create', 1, @country)
				flash[:notice]= 'Country successfully created.'
				redirect_to :action => "index"
			else
				render :action => "new"
			end
		end
	end

  def destroy
    @country.destroy
    log_change('create', 1, @country)
    redirect_to :action => "index"    
  end

  def edit
  end

	def index
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 then params[:per_page]=20 end
		if !params[:search_name] .nil? then searched_name = '%'+params[:search_name]+'%' else searched_name='%' end
		if params[:sort] .nil? then  params[:sort]="upper(countries.name)" end
		
		@pagin = Country.find(:all, :conditions => ["countries.name iLIKE ?", searched_name])
		@help_paginate = @pagin.length
		if @help_paginate.to_i <= (params[:per_page].to_i * (params[:page].to_i - 1)) then params[:page] = 1 end

		@countries = Country.paginate  :per_page => params[:per_page],
														:order => params[:sort],
														:page => params[:page],
														:conditions => ["countries.name iLIKE ?", searched_name]
		@count=@countries.total_entries
		 
		if request.xml_http_request?						
			render :partial => "countrylist" 
		end

	end

	def new
		@country = Country.new
	end

  def show
  end

	def update
		if @country.update_attributes(params[:country])
			log_change('update', 1, @country)
			flash[:notice] = 'Country successfully updated.'
			redirect_to :action => "show", :id => params[:id]
		else
			render :action => "edit"
		end
	end
  
	private
	def find_country
		@country = Country.find(params[:id])
	end


end
