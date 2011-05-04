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

class AuthorsController < ApplicationController
before_filter :editor_required, :except => [:index, :show, :reset_search, :show_from_old_url]
before_filter :find_author, :except => [:index, :new, :create, :reset_search, :show_from_old_url, :searchbox, :excel]

	def excel
		get_conditions
		@author_ids = Author.find(:all, :conditions => @conditions, :include => [:pseudonyms, :countries, :languages], :order => params[:sort])
		render :layout => "excel" 
		headers["Content-Type"] = "application/ms-excel"
		return
	end
	
	
	def index
		
		find_help("authors", "index")
	
		session[:work_results_array] = ""
		session[:reception_results_array] = ""
		
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end		
		elsif params[:per_page].to_i>500 then params[:per_page]=500 
		end
		if params[:searchtoggle].blank?
			unless session[:author_searchtoggle].blank?
				params[:searchtoggle] = session[:author_searchtoggle]
			else params[:searchtoggle] = "on"
			end
		end
		if params[:sort].nil? then params[:sort]="upper(authors.name)" end
		if params[:gender].nil? then params[:gender]="" end
		
		get_conditions
		
		#pagination
	  	@authors = Author.paginate  :per_page => params[:per_page],
														:include => [:pseudonyms, :countries, :languages],
														:order => params[:sort],
														:page => params[:page],
														:conditions => @conditions
		
		#makes sure the pagination goes back to page one when there are less records
		if @authors.out_of_bounds? then
			params[:page]=1
			@authors = Author.paginate  :per_page => params[:per_page],
														:include => [:pseudonyms, :countries, :languages],
														:order => params[:sort],
														:page => params[:page],
														:conditions => @conditions
		end
		@count=@authors.total_entries
		
		#ids of found receptions are put in an array, and the length of the array is put in a session variable
		@results_array = Array.new
		@authors.each do |author|
			@results_array << author.id
		end
		@results_array.uniq!

		if request.xml_http_request?						
			render :partial => "authorlist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:author_authorname] = params[:authorname]
		session[:author_pseudonymflag] = params[:pseudonymflag]
		session[:author_no_reader] = params[:no_reader]
		session[:author_personal_situation] = params[:personal_situation]
		session[:author_financial_situation] = params[:financial_situation]
		session[:author_notes] = params[:notes]
		session[:author_bibliography] = params[:bibliography]
		session[:author_country_ids] = params[:country_ids]
		session[:author_gender] = params[:gender]
		session[:author_year] = params[:year]
		session[:author_searchtoggle] = params[:searchtoggle]
		session[:author_results_array] = @results_array
		session[:author_results_length] = @results_array.length
	
	end

	def reset_search
		session[:author_authorname] = ""
		session[:author_pseudonymflag] = "1"
		session[:author_no_reader] = "1"
		session[:author_personal_situation] = ""
		session[:author_financial_situation] = ""
		session[:author_notes] = ""
		session[:author_bibliography] = ""
		session[:author_country_ids] = ""
		session[:author_gender] = ""
		session[:author_year] = ""
		redirect_to :controller => 'authors'
	end

	def new
		@author = Author.new
		find_help("authors", "form")
	end
	
	def create
		@author = Author.new(params[:author])
		if @author.save
			if admin? then log_change('create', 1, @author) else log_change('create', 0, @author) end
			flash[:notice]= 'Author successfully created.'
			redirect_to :action => "index"
		else
			render :action => "new"
		end
	end
	
	def show
		
		@countryline = @author.countries.collect { |t| t.name }.join(' - ')
		@languageline = @author.languages.collect { |t| t.language }.join(' - ')
		@pseudonymline = @author.pseudonyms.collect { |t| t.pseudonym }.join(' - ') 
		
		#gets the array of ids, checks what position the current record has, and gets the previous en next record ids.
		if !session[:author_results_array].blank?
			@results_array = session[:author_results_array]
			@position = @results_array.index(@author.id)
			@previous_author = @results_array[@position.to_i - 1]
			@next_author = @results_array[@position.to_i + 1]
			@results_length = session[:author_results_length]
		else 
			@position = ""
		end
		
	end
	
	def show_from_old_url
		redirect_to :controller => 'authors', :action => 'show', :id => params[:authorID]
	end

	def edit
		find_help("authors", "form")
	end

	def update
    find_help("authors", "form")
	
		# Add one or more new pseudonyms
		 (params[:pseudonyms].each do |one|
			@author.pseudonyms.create(one) unless one['pseudonym'].blank?
		end) unless params[:pseudonyms].nil?
		
		# Add one or more new urls
		(params[:author_urls].each do |one|
			@author.author_urls.create(one) unless one['url'].blank?
		end) unless params[:author_urls].nil?
		
		# Add new relation
		if((!params[:relation].nil?) and (!params[:relation][:id].blank?))
			if (params[:relation][:type].to_i>99)
				newtype=(params[:relation][:type].to_i/100).to_s
				Relation.create(:author_id => params[:relation][:id], :relative_id =>params[:id], :relation_type_id=>newtype )
			else
				Relation.create(:author_id => params[:id], :relative_id =>params[:relation][:id], :relation_type_id=>params[:relation][:type] )
			end
		end
		
		if params[:backtoauthor]=='country'
			@author.update_attributes(params[:author])
			redirect_to :controller => 'countries', :action => 'new', :author_id => @author.id, :backtoauthor => 'country'
		elsif params[:backtoauthor]=='language'
			@author.update_attributes(params[:author])
			redirect_to :controller => 'languages', :action => 'new', :author_id => @author.id, :backtoauthor => 'language'
		elsif params[:backtoauthor]=='other'
			@author.update_attributes(params[:author])
			render :action => "edit"
		elsif @author.update_attributes(params[:author])
			if admin? then log_change('update', 1, @author) else log_change('update', 0, @author) end
			flash[:notice] = 'Author successfully updated.'
			redirect_to :action => "show", :id => params[:id]
		else
			render :action => "edit"
		end
	end
	
	def searchbox
		if session[:author_searchtoggle] == 'on' then session[:author_searchtoggle] = "off"
		else session[:author_searchtoggle] = "on" end
		redirect_to :action => "index"
	end
	
	def destroy
	  @author.destroy
    log_change('delete', 1, @author)
    flash[:notice] = 'Author successfully deleted.'
		redirect_to :action => "index"
	end

	private
	def find_author
	  begin
	    @author = Author.find(params[:id])
	  rescue ActiveRecord::RecordNotFound
		  flash[:notice] = 'Author does not exist in database.'
		  redirect_to :action => "index"
		end
	end
	
	def get_conditions
			unless params[:fromauthorsearch] == '1' 
			if params[:authorname].blank? then params[:authorname] = session[:author_authorname] end
			if session[:author_pseudonymflag]=='0' then params[:pseudonymflag]='0' else params[:pseudonymflag]='1' end
			if session[:author_no_reader]== "true" then params[:no_reader]=='true' else params[:no_reader]=='false' end
			if params[:personal_situation].blank? then params[:personal_situation] = session[:author_personal_situation] end
			if params[:financial_situation].blank? then params[:financial_situation] = session[:author_financial_situation] end
			if params[:notes].blank? then params[:notes] = session[:author_notes] end
			if params[:bibliography].blank? then params[:bibliography] = session[:author_bibliography] end
      if params[:country_ids].blank? then params[:country_ids] = session[:author_country_ids] end
      if params[:language_ids].blank? then params[:language_ids] = session[:author_language_ids] end
      if params[:gender].blank? then params[:gender] = session[:author_gender] end
			if params[:year].blank? then params[:year] = session[:author_year] end
		end
		
		
		structure="1=1 ";
		if !params[:authorname].blank? 
			if (params[:pseudonymflag]=='1')
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname) OR (authors.spouse iLIKE :name) OR (authors.spouse iLIKE :leftname) OR (authors.spouse iLIKE :rightname) OR (pseudonyms.pseudonym iLIKE :name) OR (pseudonyms.pseudonym iLIKE :leftname) OR (pseudonyms.pseudonym iLIKE :rightname)) "
			else
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname)) "
			end
		end
		
		if params[:no_reader]=='true' then  structure+=" AND reader = false"  end
		
		unless params[:bibliography].blank? 
			structure+=" AND ((authors.bibliography iLIKE :bibliography) OR (authors.bibliography iLIKE :leftbibliography) OR (authors.bibliography iLIKE :rightbibliography)) "
		end
		
		unless params[:personal_situation].blank? 
			structure+=" AND ((authors.personal_situation iLIKE :personal_situation) OR (authors.personal_situation iLIKE :leftpersonal_situation) OR (authors.personal_situation iLIKE :rightpersonal_situation)) "
		end
		
		unless params[:financial_situation].blank? 
			structure+=" AND ((authors.financial_situation iLIKE :financial_situation) OR (authors.financial_situation iLIKE :leftfinancial_situation) OR (authors.financial_situation iLIKE :rightfinancial_situation)) "
		end
		
		unless params[:notes].blank? 
			structure+=" AND ((authors.notes iLIKE :notes) OR (authors.notes iLIKE :leftnotes) OR (authors.notes iLIKE :rightnotes)) "
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
		
		unless params[:gender].blank?
			structure+=" AND authors.gender = :gender "
		end
		
		if ((!params[:year].blank?) and (params[:year]!="0"))
			structure+=" AND (authors.year_born <= :year )"
			structure+=" AND (authors.year_death >= :year )"
		end

		valuehash={
			:name => "%#{params[:authorname]}%", 
			:leftname => "%#{params[:authorname]}",
			:rightname => "#{params[:authorname]}%",
			:personal_situation => "%#{params[:personal_situation]}%", 
			:leftpersonal_situation => "%#{params[:personal_situation]}", 
			:rightpersonal_situation => "#{params[:personal_situation]}%", 
			:financial_situation => "%#{params[:financial_situation]}%", 
			:leftfinancial_situation => "%#{params[:financial_situation]}", 
			:rightfinancial_situation => "#{params[:financial_situation]}%",
			:notes => "%#{params[:notes]}%", 
			:leftnotes => "%#{params[:notes]}", 
			:rightnotes => "#{params[:notes]}%",
			:bibliography => "%#{params[:bibliography]}%", 
			:leftbibliography => "%#{params[:bibliography]}", 
			:rightbibliography => "#{params[:bibliography]}%", 
			:year => params[:year],
			:gender => params[:gender]
		}
		
		@conditions=[structure, valuehash]
	end
	
end
