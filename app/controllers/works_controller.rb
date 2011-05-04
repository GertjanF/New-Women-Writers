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

class WorksController < ApplicationController
before_filter :editor_required, :except => [:index, :show, :reset_search, :show_from_old_url]
before_filter :find_author, :except => [:reset_search]
before_filter :find_work, :except => [:index, :new, :create, :reset_search, :show_from_old_url]


	def excel
		get_conditions
		@work_ids = Work.find(:all, :conditions => @conditions, 
															:include => [:genres, :topois, :language, :libraries, :country,{:author=>[:countries, :pseudonyms]}],
															:order => params[:sort])
		render :layout => "excel" 
		headers["Content-Type"] = "application/ms-excel"
		return
	end
	
	
	def index
		
		find_help('works', 'index')
		
		session[:author_results_array] = ""
		session[:reception_results_array] = ""
		if @author
			redirect_to :controller=>"authors", :action => "show", :id => @author.id
		else
			@works = Work.works
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
			unless session[:work_searchtoggle].blank?
				params[:searchtoggle] = session[:work_searchtoggle]
			else params[:searchtoggle] = "on"
			end
		end
		if params[:sort] .nil? then  params[:sort]="upper(authors.name)" end
		
		get_conditions
		
		#pagination
	  	@works = Work.paginate  		:select => "distinct work.* ",
														:include => [:genres, :topois, :language, :libraries, :country,{:author=>[:countries, :pseudonyms]}],
														:order => params[:sort],
														:per_page => params[:per_page],
														:page => params[:page],
														:conditions => @conditions
# voor zoeken op pseudonyms dit toevoegen in join of select {:author=>:pseudonyms}

		#makes sure the pagination goes back to page one when there are less records
		if @works.out_of_bounds? then
			params[:page]=1
			@works = Work.paginate  	:select => "distinct work.* ",
																:per_page => params[:per_page],
																:include => [:genres, :topois, :language, :libraries, :country,{:author=>[:countries, :pseudonyms]}],
																:order => params[:sort],
																:page => params[:page],
																:conditions => @conditions
		end
		@count=@works.total_entries

		#ids of found receptions are put in an array, and the length of the array is put in a session variable
		@results_array = Array.new
		@works.each do |work|
			@results_array << work.id
		end
		@results_array.uniq!

		if request.xml_http_request?						
			render :partial => "worklist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:work_workauthor] = params[:workauthor]
		session[:work_pseudonymflag] = params[:pseudonymflag]
		session[:work_authorcountry_ids] = params[:authorcountry_ids]
		session[:work_worktitle] = params[:worktitle]
		session[:work_country_ids] = params[:country_ids]
		session[:work_language_ids] = params[:language_ids]
		session[:work_workyear] = params[:workyear]
		session[:work_genre_ids] = params[:genre_ids]
		session[:work_worktopos] = params[:worktopos]
		session[:work_notes] = params[:notes]
		session[:work_library_ids] = params[:library_ids]
		session[:work_searchtoggle] = params[:searchtoggle]
		session[:work_results_array] = @results_array
		session[:work_results_length] = @results_array.length
		
	end

	def reset_search
		session[:work_workauthor] = ""
		session[:work_pseudonymflag] = "1"
		session[:work_authorcountry_ids] = ""
		session[:work_worktitle] = ""
		session[:work_country_ids] = ""
		session[:work_language_ids] = ""
		session[:work_workyear] = ""
		session[:work_genre_ids] = ""
		session[:work_worktopos] = ""	
		session[:work_library_ids] = ""
		session[:work_notes] = ""
		redirect_to :controller => 'works'
	end
	
	def new
		@work = Work.new
		find_help("works", "form")
	end
	
	def create
		@work = Work.new(params[:work])
		@work.author.update_attribute(:reader, false)
		if @author
			if @author.works << @work
				if admin? then log_change('create', 1, @work) else log_change('create', 0, @work) end
				redirect_to_author('Work successfully created.')
			else
				render :action => "new"
			end
		else
			if @work.save
				if admin? then log_change('create', 1, @work) else log_change('create', 0, @work) end
				flash[:notice] = 'Work successfully created.'
				redirect_to :action => "index"
			else
				render :action => "new"
			end
		end
	end	
	
	
	def edit
		find_help("works", "form")
	end

	def show
		if @author
			redirect_to_author('')
		end
		@genreline = @work.genres.collect { |t| t.genre }.join(', ')
		@toposline = @work.topois.collect { |t| t.topos }.join(', ')
			
		#gets the array of ids, checks what position the current record has, and gets the previous en next record ids.
		if !session[:work_results_array].blank?
			@results_array = session[:work_results_array]
			@position = @results_array.index(@work.id)
			@previous_work = @results_array[@position.to_i - 1]
			@next_work = @results_array[@position.to_i + 1]
			@results_length = session[:work_results_length]
		else 
			@position = ""
		end
		
	end
	
	def show_from_old_url
		redirect_to :controller => 'works', :action => 'show', :id => params[:workID]
	end

	def update
		(params[:prints].each do |one|
			@work.prints.create(one) unless one['print'].empty?
		end) unless params[:prints].nil?

		(params[:work_urls].each do |one|
			@work.work_urls.create(one) unless one['url'].empty?
		end) unless params[:work_urls].nil?
		
    find_help("works", "form")
		  
		if params[:backtowork]=='print'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'prints', :action => 'new', :work_id => @work.id, :backtowork => 'print'
		elsif params[:backtowork]=='genre'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'genres', :action => 'new', :work_id => @work.id, :backtowork => 'genre'
		elsif params[:backtowork]=='country'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'countries', :action => 'new', :work_id => @work.id, :backtowork => 'country'
		elsif params[:backtowork]=='language'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'languages', :action => 'new', :work_id => @work.id, :backtowork => 'language'
		elsif params[:backtowork]=='topos'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'topois', :action => 'new', :work_id => @work.id, :backtowork => 'topos'
		elsif params[:backtowork]=='library'
			@work.update_attributes(params[:work])
			redirect_to :controller => 'libraries', :action => 'new', :work_id => @work.id, :backtowork => 'library'
		elsif params[:backtowork]=='other'
			@work.update_attributes(params[:work])
			render :action => "edit"
		elsif @work.update_attributes(params[:work])
			if admin? then log_change('update', 1, @work) else log_change('update', 0, @work) end
			if @author
					redirect_to_author('Work successfully updated.')
			else
				flash[:notice] = 'Work successfully updated.'
				redirect_to :action => "show", :id => @work.id
			end
		else
			render :action => "edit"
		end
	end
	
	def searchbox
		if session[:work_searchtoggle] == 'on' then session[:work_searchtoggle] = "off"
		else session[:work_searchtoggle] = "on" end
		redirect_to :action => "index"
	end
	
	def destroy
		@work.destroy
    log_change('delete', 1, @work)
		if @author
				redirect_to_author('Work successfully deleted.')
		else
			flash[:notice] = 'Work successfully deleted.'
			redirect_to :action => "index"
		end
	end

	private
	def redirect_to_author(notice)
		flash[:notice] = notice
		redirect_to :controller => "authors",
		:action => "show",
		:id => @author.id
	end
	
	def find_author
		if params[:author_id]
      @author = Author.find_by_id(params[:author_id])
      if @author.nil?
        flash[:notice] = 'Author does not exist in database.'
        redirect_to :action => "index"
      end 			  
		end
	end
	
	def find_work
		if @author
      @work=@author.works.find_by_id(params[:id])
      if @work.nil?
        flash[:notice] = 'Work does not exist in database.'
        redirect_to :action => "index"
      end          	  
		else
      @work = Work.find_by_id(params[:id])
		  if @work.nil?
        flash[:notice] = 'Work does not exist in database.'
        redirect_to :action => "index"
      end         
		end
	end
	
	def get_conditions
		
		unless params[:fromworksearch] == '1' 
			if params[:workauthor].blank? then params[:workauthor] = session[:work_workauthor] end
			if session[:work_pseudonymflag]=='0' then params[:pseudonymflag]='0' else params[:pseudonymflag]='1' end
			if params[:authorcountry_ids].blank? then params[:authorcountry_ids] = session[:work_authorcountry_ids] end
			if params[:worktitle].blank? then params[:worktitle] = session[:work_worktitle] end
			if params[:country_ids].blank? then params[:country_ids] = session[:work_country_ids] end
			if params[:language_ids].blank? then params[:language_ids] = session[:work_language_ids] end
			if params[:workyear].blank? then params[:workyear] = session[:work_workyear] end
			if params[:genre_ids].blank? then params[:genre_ids] = session[:work_genre_ids] end
			if params[:worktopos].blank? then params[:worktopos] = session[:work_worktopos] end
			if params[:notes].blank? then params[:notes] = session[:work_notes] end
			if params[:library_ids].blank? then params[:library_ids] = session[:work_library_ids] end
		end

		structure="1=1 ";

		if !params[:workauthor].blank? 
			if (params[:pseudonymflag]=='1')
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname) OR (authors.spouse iLIKE :name) OR (authors.spouse iLIKE :leftname) OR (authors.spouse iLIKE :rightname) OR (pseudonyms.pseudonym iLIKE :name) OR (pseudonyms.pseudonym iLIKE :leftname) OR (pseudonyms.pseudonym iLIKE :rightname)) "
			else
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname)) "
			end
		end
		
		
		unless params[:authorcountry_ids].blank?
			structure+=" AND ("
			params[:authorcountry_ids].each do |value|
				structure+=" countries_authors.id ="+value+" OR "
			end
			structure+="1=0)"
		end
		
		
		unless params[:worktitle].blank? 
			structure+=" AND ((works.title iLIKE :title) OR (works.title iLIKE :lefttitle) OR (works.title iLIKE :righttitle)) "
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
		
		unless params[:workyear].blank? 
			structure+=" AND (works.publish_year = :year) "
		end
		
		unless params[:genre_ids].blank?
			structure+=" AND ("
			params[:genre_ids].each do |value|
				structure+=" genres.id ="+value+" OR "
			end
			structure+="1=0)"
		end
		
		unless params[:worktopos].blank? 
			structure+=" AND ((topois.topos iLIKE :topos) OR (topois.topos iLIKE :lefttopos) OR (topois.topos iLIKE :righttopos)) "
		end
		
		unless params[:library_ids].blank?
			structure+=" AND ("
			params[:library_ids].each do |value|
				structure+=" libraries.id ="+value+" OR "
			end
			structure+="1=0)"
		end
		
		unless params[:notes].blank? 
			structure+=" AND ((works.notes iLIKE :notes) OR (works.notes iLIKE :leftnotes) OR (works.notes iLIKE :rightnotes)) "
		end

		valuehash={
			:name => "%#{params[:workauthor]}%", 
			:leftname => "%#{params[:workauthor]}",
			:rightname => "#{params[:workauthor]}%",
			:title => "%#{params[:worktitle]}%", 
			:lefttitle => "%#{params[:worktitle]}", 
			:righttitle => "#{params[:worktitle]}%", 
			:year => params[:workyear],
			:topos => "%#{params[:worktopos]}%",
			:lefttopos => "%#{params[:worktopos]}",
			:righttopos => "#{params[:worktopos]}%",
			:notes => "%#{params[:notes]}%", 
			:leftnotes => "%#{params[:notes]}", 
			:rightnotes => "#{params[:notes]}%"
		}
		
		@conditions=[structure, valuehash]
	end
end
