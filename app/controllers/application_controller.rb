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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
	
	before_filter :initialize_user
	before_filter :get_help_application

	#make these available as ActionView helper methods.
	helper_method :logged_in?, :editor?, :admin?
	
	def admin?
		logged_in? && @current_user.level == 1
	end
	
	def editor?
		logged_in? && @current_user.level == 2 or logged_in? && @current_user.level == 1
	end
	
	def logged_in?
		@current_user.is_a?(User)
	end
	
	def search_from_old_url
	#logger.info('BENBEN'+params.inspect)
		if params[:type]=='receptions' then
			redirect_to :controller => 'receptions', :action => 'index', 
					:fromreceptionsearch => "1",
					:country_ids => params[:RecCountry_ID],
					:workcountry_ids => params[:Country_ID],
					:receptionauthor => params[:rec_authorName],
					:receptiontitle => params[:Rec_Title],
					:gender => params[:Rec_Gender],
					:workauthor => params[:work_authorName],
					:worktitle => params[:work_Title],
					:receptionyear => params[:rec_Year],
					:medium_ids => params[:media_ID],
					:source_ids => params[:source_ID],
					:references => params[:reference],
					:notes => params[:notesfield],
					:per_page => params[:pageSize]
		end
		if params[:type]=='works' then
			redirect_to :controller => 'works', :action => 'index', 
					:fromworksearch => "1",
					:worktopos => params[:topos],
					:country_ids => params[:Country_ID],
					:workauthor => params[:authorName],
					:pseudonymflag => params[:pseudonym],
					:worktitle => params[:workTitle],
					:genre_ids => params[:Genre_ID],
					:workyear => params[:workYear],
					:notes => params[:notesfield],
					:per_page => params[:pageSize]
		end   
		if params[:type]=='authors' then
			redirect_to :controller => 'authors', :action => 'index', 
					:fromauthorsearch => "1",
					:authorname => params[:authorName],
					:pseudonymflag => params[:pseudonym],
					:gender => params[:gender],
					:year => params[:year],
					:country_ids => params[:Country_ID],
					:bibliography => params[:bibliography],
					:per_page => params[:pageSize],
					:notes => params[:notesfield],
					:personal_situation => params[:personal],
					:financial_situation => params[:professional],
					:no_reader => '0'
		end
	end
	
	protected

	#Check if the user is already logged in
	
	def log_change(type, approved, changed_object)
		Change.create(:object_name => controller_name, :approved => approved, :changetype => type, :user_id => @current_user.id, :object_id => changed_object.id, :object_type => changed_object.class.name)
	end
	
	def login_required
		redirect_to_login unless logged_in?
	end
	
	def editor_required
		redirect_to_login unless editor?
	end

	def admin_required
		redirect_to_login unless admin?
	end

	def redirect_to_login
		redirect_to(:controller=> 'sessions',:action=> 'new')
	end
	
	#setup user info on each page
	def initialize_user
		@current_user = User.find_by_id(session[:user]) if session[:user]
	end
	
	def get_help_application
		@help_application = Help.find(:first, :conditions => "(helps.object_controller iLIKE 'homepage') AND (helps.object_action iLIKE 'index')")
	end

	def find_help(object_controller, object_action)
		structure="(helps.object_controller iLIKE :object_controller) AND (helps.object_action iLIKE :object_action)";
		
		valuehash={
			:object_controller => object_controller, 
			:object_action => object_action
		}
		
		@conditions=[structure, valuehash]
	
		@help_page = Help.find(:first, :conditions => @conditions)
	end
	
end
