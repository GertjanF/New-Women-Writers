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

class SearchesController < ApplicationController
before_filter :find_all

	def authors
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end	
		end
		if params[:sort].nil? then params[:sort]="authors.name" end
		if params[:gender].nil? then params[:gender]="" end
		
		unless params[:fromauthorsearch] == '1' 
			if params[:authorname].blank? then params[:authorname] = session[:author_authorname] end
			if session[:author_pseudonymflag]=='0' then params[:pseudonymflag]='0' else params[:pseudonymflag]='1' end
			if session[:author_no_reader]=='0' then params[:no_reader]=='0' else params[:no_reader]=='1' end
			if params[:bibliography].blank? then params[:bibliography] = session[:author_bibliography] end
			if params[:country_ids].blank? then params[:country_ids] = session[:author_country_ids] end
			if params[:gender].blank? then params[:gender] = session[:author_gender] end
			if params[:year].blank? then params[:year] = session[:author_year] end
		end
		
		structure="1=1 ";
		if !params[:authorname].blank? 
			if (params[:pseudonymflag]=='1')
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname) OR (pseudonyms.pseudonym iLIKE :name ) OR (pseudonyms.pseudonym iLIKE :leftname ) OR (pseudonyms.pseudonym iLIKE :rightname )) "
			else
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname)) "
			end
		end
		
		if params[:no_reader]=='1' then  structure+=" AND reader = false"  end
		
		unless params[:bibliography].blank? 
			structure+=" AND ((authors.bibliography iLIKE :bibliography) OR (authors.bibliography iLIKE :leftbibliography) OR (authors.bibliography iLIKE :rightbibliography)) "
		end
		

		unless params[:country_ids].blank?
			structure+=" AND ("
			params[:country_ids].each do |value|
				structure+=" countries.id ="+value+" OR "
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
			:bibliography => "%#{params[:bibliography]}%", 
			:leftbibliography => "%#{params[:bibliography]}", 
			:rightbibliography => "#{params[:bibliography]}%", 
			:year => params[:year],
			:gender => params[:gender]
		}
		
		conditions=[structure, valuehash]
	  	@authors = Author.paginate  :per_page => params[:per_page],
														:include => [:pseudonyms, :countries],
														:order => params[:sort],
														:page => params[:page],
														:conditions => conditions
		@count=@authors.total_entries
		
		logger.info('conditions '+conditions.inspect)

		if request.xml_http_request?						
			render :partial => "authorlist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:author_authorname] = params[:authorname]
		session[:author_pseudonymflag] = params[:pseudonymflag]
		session[:author_no_reader] = params[:no_reader]
		session[:author_bibliography] = params[:bibliography]
		session[:author_country_ids] = params[:country_ids]
		session[:author_gender] = params[:gender]
		session[:author_year] = params[:year]
	
	end

	def author_empty_search
		session[:author_authorname] = ""
		session[:author_pseudonymflag] = "1"
		session[:author_no_reader] = "1"
		session[:author_bibliography] = ""
		session[:author_country_ids] = ""
		session[:author_gender] = ""
		session[:author_year] = ""
		redirect_to :action => 'authors'
	end
	
	def receptions
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end	
		end
		if params[:sort] .nil? then  params[:sort]="receptions.title" end

		unless params[:fromreceptionsearch] == '1' 
			if params[:workauthor].blank? then params[:workauthor] = session[:reception_workauthor] end
			if params[:worktitle].blank? then params[:worktitle] = session[:reception_worktitle] end
#			if params[:workcountry_id].blank? then params[:workcountry_id] = session[:rworkcountry_id] end
			if params[:receptionauthor].blank? then params[:receptionauthor] = session[:reception_receptionauthor] end
			if params[:gender].blank? then params[:gender] = session[:reception_gender] end
			if params[:receptiontitle].blank? then params[:receptiontitle] = session[:reception_receptiontitle] end
			if params[:medium_ids].blank? then params[:medium_ids] = session[:reception_medium_ids] end
			if params[:receptionyear].blank? then params[:receptionyear] = session[:reception_receptionyear] end
			if params[:country_ids].blank? then params[:country_ids] = session[:reception_country_ids] end
			if params[:source_ids].blank? then params[:source_ids] = session[:reception_source_ids] end
			if params[:references].blank? then params[:references] = session[:reception_references] end
		end
		
		structure="1=1 ";

		unless params[:workauthor].blank? 
			structure+="AND ((authors_works.name iLIKE :workauthor) OR (authors_works.name iLIKE :leftworkauthor) OR (authors_works.name iLIKE :rightworkauthor))"
		end
		
		unless params[:worktitle].blank? 
			structure+=" AND ((works.title iLIKE :worktitle) OR (works.title iLIKE :leftworktitle) OR (works.title iLIKE :rightworktitle)) "
		end
		
=begin
		unless params[:workcountry_id].blank?
			structure+=" AND authors_countries.id =:workcountry_id "
		end
=end

		unless params[:receptionauthor].blank? 
			structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname)) "
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

		valuehash={
			:workauthor => "%#{params[:workauthor]}%", 
			:leftworkauthor => "%#{params[:workauthor]}", 
			:rightworkauthor => "#{params[:workauthor]}%", 
			:worktitle => "%#{params[:worktitle]}%", 
			:leftworktitle => "%#{params[:worktitle]}", 
			:rightworktitle => "#{params[:worktitle]}%", 
			:workcountry_id => params[:workcountry_id],
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
			:rightreferences => "#{params[:references]}%"
		}
		
		conditions=[structure, valuehash]
	  	@receptions = Reception.paginate  	:per_page => params[:per_page],
																	:joins => [:medium, :source, :country, :author, {:work => :author}],
																	:order => params[:sort],
																	:page => params[:page],
																	:conditions => conditions
		@count=@receptions.total_entries

		logger.info('conditions '+conditions.inspect)

		if request.xml_http_request?						
			render :partial => "receptionlist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:reception_workauthor] = params[:workauthor]
		session[:reception_worktitle] = params[:worktitle]
#		session[:rworkcountry_id] = params[:workcountry_id]
		session[:reception_receptionauthor] = params[:receptionauthor]
		session[:reception_gender] = params[:gender]
		session[:reception_receptiontitle] = params[:receptiontitle]
		session[:reception_medium_ids] = params[:medium_ids]
		session[:reception_receptionyear] = params[:receptionyear]
		session[:reception_country_ids] = params[:country_ids]
		session[:reception_source_ids] = params[:source_ids]
		session[:reception_references] = params[:references]
		
	end

	def reception_empty_search
		session[:reception_workauthor] = ""
		session[:reception_worktitle] = ""
#		session[:rworkcountry_id] = ""
		session[:reception_receptionauthor] = ""
		session[:reception_gender] = ""
		session[:reception_receptiontitle] = ""
		session[:reception_medium_ids] = ""
		session[:reception_receptionyear] = ""
		session[:reception_country_ids] = ""
		session[:reception_source_ids] = ""
		session[:reception_references] = ""
		redirect_to :action => 'receptions'
	end
	
	def works
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end	
		end
		if params[:sort] .nil? then  params[:sort]="works.title" end
		
		unless params[:fromworksearch] == '1' 
			if params[:workauthor].blank? then params[:workauthor] = session[:work_workauthor] end
			if session[:work_pseudonymflag]=='0' then params[:pseudonymflag]='0' else params[:pseudonymflag]='1' end
			if params[:worktitle].blank? then params[:worktitle] = session[:work_worktitle] end
			if params[:country_ids].blank? then params[:country_ids] = session[:work_country_ids] end
			if params[:workyear].blank? then params[:workyear] = session[:work_workyear] end
			if params[:genre_ids].blank? then params[:genre_ids] = session[:work_genre_ids] end
			if params[:worktopos].blank? then params[:worktopos] = session[:work_worktopos] end
		end

		structure="1=1 ";

		if !params[:workauthor].blank? 
			if (params[:pseudonymflag]=='1')
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname) OR (pseudonyms.pseudonym iLIKE :name) OR (pseudonyms.pseudonym iLIKE :leftname) OR (pseudonyms.pseudonym iLIKE :rightname)) "
			else
				structure+="AND ((authors.name iLIKE :name) OR (authors.name iLIKE :leftname) OR (authors.name iLIKE :rightname)) "
			end
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
			:righttopos => "#{params[:worktopos]}%"
		}
		
		conditions=[structure, valuehash]
	  	@works = Work.paginate  		:select => "distinct work.* ",
														:joins => [{:author=>:pseudonyms},{:author=>:countries}],
														:include => [:genres, :topois],
														:order => params[:sort],
														:per_page => params[:per_page],
														:page => params[:page],
														:conditions => conditions
		@count=@works.total_entries

		logger.info('conditions '+conditions.inspect)

		if request.xml_http_request?						
			render :partial => "worklist" 
		end
		
		session[:per_page] = params[:per_page]
		session[:work_workauthor] = params[:workauthor]
		session[:work_pseudonymflag] = params[:pseudonymflag]
		session[:work_worktitle] = params[:worktitle]
		session[:work_country_ids] = params[:country_ids]
		session[:work_workyear] = params[:workyear]
		session[:work_genre_ids] = params[:genre_ids]
		session[:work_worktopos] = params[:worktopos]
		
	end

	def work_empty_search
		session[:work_workauthor] = ""
		session[:work_pseudonymflag] = "1"
		session[:work_worktitle] = ""
		session[:work_country_ids] = ""
		session[:work_workyear] = ""
		session[:work_genre_ids] = ""
		session[:work_worktopos] = ""	
		redirect_to :action => 'works'
	end

private
	def find_all
		@countries = Country.find(:all, :order => 'countries.name')
		@media = Medium.find(:all, :order => 'media.medium')
		@genres = Genre.find(:all, :order => 'genres.genre')
		@sources = Source.find(:all, :order => 'sources.short_name')
	end
	
end