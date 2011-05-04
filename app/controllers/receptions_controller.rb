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

class ReceptionsController < ApplicationController
before_filter :editor_required, :except => [:index, :show, :reset_search, :show_from_old_url]
before_filter :find_work
before_filter :find_reception, :except => [:index, :new, :create, :reset_search, :show_from_old_url]


	def excel
		get_conditions
		@reception_ids = Reception.find(:all, :conditions => @conditions, 
															:joins => [:medium, :source], 
															:include => [:language, :libraries, :country, {:author=>:pseudonyms}, {:work => [{:author=>:pseudonyms}, :country]}],
															:order => params[:sort])
		render :layout => "excel" 
		headers["Content-Type"] = "application/ms-excel"
		return
	end
	
	
	def index
	
		find_help("receptions", "index")
	
		session[:work_results_array] = ""
		session[:author_results_array] = ""
		
		if @work
			redirect_to :controller=>"works", :action => "show", :id => @work.id
		else
			@receptions = Reception.receptions
		end

		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end	
		elsif params[:per_page].to_i>500 then params[:per_page]=500
		end
		if params[:searchtoggle].blank?
			unless session[:reception_searchtoggle].blank?
				params[:searchtoggle] = session[:reception_searchtoggle]
			else params[:searchtoggle] = "on"
			end
		end
		if params[:sort] .nil? then  params[:sort]="upper(authors_works.name)" end
		
		get_conditions
		
		#pagination
	  	@receptions = Reception.paginate  	:per_page => params[:per_page],
								:joins => [:medium, :source],
								:include => [:language, :libraries, :country, {:author=>:pseudonyms}, {:work => [{:author=>:pseudonyms}, :country]}],
								:order => params[:sort],
								:page => params[:page],
								:conditions => @conditions

		#makes sure the pagination goes back to page one when there are less records
		if @receptions.out_of_bounds? then
			params[:page]=1
			@receptions = Reception.paginate  	:per_page => params[:per_page],
								:joins => [:medium, :source],
								:include => [:language, :libraries, :country, {:author=>:pseudonyms}, {:work => [{:author=>:pseudonyms}, :country]}],
								:order => params[:sort],
								:page => params[:page],
								:conditions => @conditions
		end
		@count=@receptions.total_entries

		#ids of found receptions are put in an array, and the length of the array is put in a session variable
		@results_array = Array.new
		@receptions.each do |reception|
			@results_array << reception.id
		end
		@results_array.uniq!

		if request.xml_http_request?						
			render :partial => "receptionlist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:reception_workauthor] = params[:workauthor]
		session[:reception_worktitle] = params[:worktitle]
		session[:reception_workcountry_ids] = params[:workcountry_ids]
		session[:reception_receptionauthor] = params[:receptionauthor]
		session[:reception_gender] = params[:gender]
		session[:reception_receptiontitle] = params[:receptiontitle]
		session[:reception_medium_ids] = params[:medium_ids]
		session[:reception_receptionyear] = params[:receptionyear]
		session[:reception_country_ids] = params[:country_ids]
		session[:reception_language_ids] = params[:language_ids]
		session[:reception_source_ids] = params[:source_ids]
		session[:reception_references] = params[:references]
		session[:reception_library_ids] = params[:library_ids]
		session[:reception_notes] = params[:notes]
		session[:reception_searchtoggle] = params[:searchtoggle]
		session[:reception_results_length] = @results_array.length
		session[:reception_results_array] = @results_array
		
	end

	def reset_search
		session[:reception_workauthor] = ""
		session[:reception_worktitle] = ""
		session[:reception_workcountry_ids] = ""
		session[:reception_receptionauthor] = ""
		session[:reception_gender] = ""
		session[:reception_receptiontitle] = ""
		session[:reception_medium_ids] = ""
		session[:reception_receptionyear] = ""
		session[:reception_country_ids] = ""
		session[:reception_language_ids] = ""
		session[:reception_source_ids] = ""
		session[:reception_references] = ""
		session[:reception_library_ids] = ""
		session[:reception_notes] = ""
		redirect_to :controller => 'receptions'
	end

	def new
		@reception = Reception.new
		if @work.nil?
			@work_author_name = "<i>[choose work first]</i>"
		else
			@work_author_name = @work.author.name 
		end
		find_help("receptions", "form")
	end
	
	def create
		@reception = Reception.new(params[:reception])
		if @work
			if @work.receptions << @reception
				if admin? then log_change('create', 1, @reception) else log_change('create', 0, @reception) end
				redirect_to_work('Reception successfully created.')
			else
				render :action => "new"
			end
		else
			if @reception.save
				if admin? then log_change('create', 1, @reception) else log_change('create', 0, @reception) end
				flash[:notice] = 'Reception successfully created.'
				redirect_to :action => "index"
			else
				render :action => "new"
			end
		end
	end
	
	def show
		if @work
			redirect_to_work('')
		end
		
		#gets the array of ids, checks what position the current record has, and gets the previous en next record ids.
		if !session[:reception_results_array].blank?
			@results_array = session[:reception_results_array]
			@position = @results_array.index(@reception.id)
			@previous_reception = @results_array[@position.to_i - 1]
			@next_reception = @results_array[@position.to_i + 1]
			@results_length = session[:reception_results_length]
		else 
			@position = ""
		end
		
	end
		
	def show_from_old_url
		redirect_to :controller => 'receptions', :action => 'show', :id => params[:receptionID]
	end

	def edit
		@work_author_name = @reception.work.author.name
		find_help("receptions", "form")
	end

	def update
		(params[:reception_urls].each do |one|
			@reception.reception_urls.create(one) unless one['url'].empty?
		end) unless params[:reception_urls].nil?
		
    find_help("receptions", "form") 
		
		if params[:backtoreception]=='country'
			@reception.update_attributes(params[:reception])
			redirect_to :controller => 'countries', :action => 'new', :reception_id => @reception.id, :backtoreception => 'country'
		elsif params[:backtoreception]=='language'
			@reception.update_attributes(params[:reception])
			redirect_to :controller => 'languages', :action => 'new', :reception_id => @reception.id, :backtoreception => 'language'
		elsif params[:backtoreception]=='source'
			@reception.update_attributes(params[:reception])
			redirect_to :controller => 'sources', :action => 'new', :reception_id => @reception.id, :backtoreception => 'source'
		elsif params[:backtoreception]=='medium'
			@reception.update_attributes(params[:reception])
			redirect_to :controller => 'media', :action => 'new', :reception_id => @reception.id, :backtoreception => 'medium'
		elsif params[:backtoreception]=='library'
			@reception.update_attributes(params[:reception])
			redirect_to :controller => 'libraries', :action => 'new', :reception_id => @reception.id, :backtoreception => 'library'
		elsif params[:backtoreception]=='other'
			@reception.update_attributes(params[:reception])
			render :action => "edit"
		elsif @reception.update_attributes(params[:reception])
			if admin? then log_change('update', 1, @reception) else log_change('update', 0, @reception) end
			if @work
					redirect_to_work('Reception successfully updated.')
			else
				flash[:notice] = 'Reception successfully updated.'
				redirect_to :action => "show", :id => params[:id]
			end
		else
			render :action => "edit"
		end
	end
	
	def searchbox
		if session[:reception_searchtoggle] == 'on' then session[:reception_searchtoggle] = "off"
		else session[:reception_searchtoggle] = "on" end
		redirect_to :action => "index"
	end

	def destroy
		@reception.destroy
    self.log_change('delete', 1)
		if @work
			redirect_to_work('Reception successfully deleted.')
		else
			flash[:notice] = 'Reception successfully deleted.'
			redirect_to :action => "index"
		end
	end

	# PRIVATE METHODS
	private
	
	def redirect_to_work(notice)
		flash[:notice] = notice
		redirect_to :controller => "works",
		:action => "show",
		:id => @work.id
	end

	def find_work
		if params[:work_id]
      @work = Work.find_by_id(params[:work_id])
      if @work.nil?
        flash[:notice] = 'Work does not exist in database.'
        redirect_to :action => "index"
      end 			  
		end
	end

	def find_reception
		if@work		
      @reception = @work.receptions.find_by_id(params[:id])
      if @reception.nil?
        flash[:notice] = 'Reception does not exist in database.'
        redirect_to :action => "index"
      end           
		else
      @reception = Reception.find_by_id(params[:id])
      if @reception.nil?
        flash[:notice] = 'Reception does not exist in database.'
        redirect_to :action => "index"
      end   			  
		end
	end
	
	def get_conditions

		unless params[:fromreceptionsearch] == '1' 
			if params[:workauthor].blank? then params[:workauthor] = session[:reception_workauthor] end
			if params[:worktitle].blank? then params[:worktitle] = session[:reception_worktitle] end
			if params[:workcountry_ids].blank? then params[:workcountry_ids] = session[:reception_workcountry_ids] end
			if params[:receptionauthor].blank? then params[:receptionauthor] = session[:reception_receptionauthor] end
			if params[:gender].blank? then params[:gender] = session[:reception_gender] end
			if params[:receptiontitle].blank? then params[:receptiontitle] = session[:reception_receptiontitle] end
			if params[:medium_ids].blank? then params[:medium_ids] = session[:reception_medium_ids] end
			if params[:receptionyear].blank? then params[:receptionyear] = session[:reception_receptionyear] end
			if params[:country_ids].blank? then params[:country_ids] = session[:reception_country_ids] end
			if params[:language_ids].blank? then params[:language_ids] = session[:reception_language_ids] end
			if params[:source_ids].blank? then params[:source_ids] = session[:reception_source_ids] end
			if params[:references].blank? then params[:references] = session[:reception_references] end
			if params[:library_ids].blank? then params[:library_ids] = session[:reception_library_ids] end
			if params[:notes].blank? then params[:notes] = session[:reception_notes] end
		end
		
		structure="1=1 ";


		unless params[:workauthor].blank? 
			structure+="AND ((authors_works.name iLIKE :workauthor) OR (authors_works.name iLIKE :leftworkauthor) OR (authors_works.name iLIKE :rightworkauthor) OR (authors_works.spouse iLIKE :workauthor) OR (authors_works.spouse iLIKE :leftworkauthor) OR (authors_works.spouse iLIKE :rightworkauthor) OR (pseudonyms_authors.pseudonym iLIKE :workauthor) OR (pseudonyms_authors.pseudonym iLIKE :leftworkauthor) OR (pseudonyms_authors.pseudonym iLIKE :rightworkauthor))"
		end
		
		unless params[:worktitle].blank? 
			structure+=" AND ((works.title iLIKE :worktitle) OR (works.title iLIKE :leftworktitle) OR (works.title iLIKE :rightworktitle)) "
		end
		

		unless params[:workcountry_ids].blank?
			structure+=" AND ("
			params[:workcountry_ids].each do |value|
				structure+=" countries_works.id = "+value+" OR "
			end
			structure+="1=0)"
		end

		unless params[:receptionauthor].blank? 
			structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname) OR (authors.spouse iLIKE :name) OR (authors.spouse iLIKE :leftname) OR (authors.spouse iLIKE :rightname) OR (pseudonyms.pseudonym iLIKE :name) OR (pseudonyms.pseudonym iLIKE :leftname) OR (pseudonyms.pseudonym iLIKE :rightname))"
		end
		
		unless params[:gender].blank?
			structure+=" AND authors.gender = :gender "
		end

		unless params[:receptiontitle].blank? 
			structure+=" AND ((receptions.title iLIKE :title) OR (receptions.title iLIKE :lefttitle) OR (receptions.title iLIKE :righttitle)) "
		end
		
		unless params[:medium_ids].blank?
			structure+=" AND ("
			params[:medium_ids].each do |value|
				structure+=" media.id ="+value+" OR "
			end
			structure+="1=0)"
		end
		
		unless params[:receptionyear].blank? 
			structure+=" AND (receptions.year = :year) "
		end

		unless params[:country_ids].blank?
			structure+=" AND ("
			params[:country_ids].each do |value|
				structure+=" countries.id ="+value+" OR "
			end
			structure+="1=0)"
		end

		unless params[:language_ids].blank?
			structure+=" AND ("
			params[:language_ids].each do |value|
				structure+=" languages.id ="+value+" OR "
			end
			structure+="1=0)"
		end

		unless params[:source_ids].blank?
			structure+=" AND ("
			params[:source_ids].each do |value|
				structure+=" sources.id ="+value+" OR "
			end
			structure+="1=0)"
		end

		unless params[:references].blank? 
			structure+=" AND ((receptions.references iLIKE :references) OR (receptions.references iLIKE :leftreferences) OR (receptions.references iLIKE :rightreferences)) "
		end
		
		unless params[:library_ids].blank?
			structure+=" AND ("
			params[:library_ids].each do |value|
				structure+=" libraries.id ="+value+" OR "
			end
			structure+="1=0)"
		end
		
		unless params[:notes].blank? 
			structure+=" AND ((receptions.excerpt iLIKE :notes) OR (receptions.excerpt iLIKE :leftnotes) OR (receptions.excerpt iLIKE :rightnotes)) "
		end

		valuehash={
			:workauthor => "%#{params[:workauthor]}%", 
			:leftworkauthor => "%#{params[:workauthor]}", 
			:rightworkauthor => "#{params[:workauthor]}%", 
			:worktitle => "%#{params[:worktitle]}%", 
			:leftworktitle => "%#{params[:worktitle]}", 
			:rightworktitle => "#{params[:worktitle]}%", 
			:name => "%#{params[:receptionauthor]}%",
			:leftname => "%#{params[:receptionauthor]}",
			:rightname => "#{params[:receptionauthor]}%",
			:gender => params[:gender],
			:title => "%#{params[:receptiontitle]}%", 
			:lefttitle => "%#{params[:receptiontitle]}", 
			:righttitle => "#{params[:receptiontitle]}%", 
			:year => params[:receptionyear],
			:references => "%#{params[:references]}%",
			:leftreferences => "%#{params[:references]}",
			:rightreferences => "#{params[:references]}%",
			:notes => "%#{params[:notes]}%", 
			:leftnotes => "%#{params[:notes]}", 
			:rightnotes => "#{params[:notes]}%"
		}
		
		@conditions=[structure, valuehash]
	end
	
end