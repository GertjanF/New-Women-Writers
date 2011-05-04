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

class UsersController < ApplicationController
before_filter :admin_required, :only => [:destroy, :new, :create]
before_filter :admin_view, :only => [:index]
before_filter :login_required, :only => [:edit, :update, :show]
 before_filter :find_user, :except => [:index, :new, :create]
 before_filter :confirm_user_owns_record, :only => [:edit, :update, :show]
 
	def create
		@user = User.new(params[:user])
		if @user.save
			log_change('create', 1, @user)
			flash[:notice]= 'Successfully signed up.'
			redirect_to :action => "show", :id => @user.id
		else
			render :action => "new"
		end
	end

  def destroy
    @user.destroy
    log_change('delete', 1, @user)
    redirect_to :action => "index"
  end

  def edit
  end

	def index
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 then params[:per_page]=20 end
		if !params[:search_name] .nil? then searched_name = '%'+params[:search_name]+'%' else searched_name='%' end
		if params[:sort] .nil? then  params[:sort]="upper(users.name)" end

		@pagin = User.find(:all, :conditions => ["users.name iLIKE ?", searched_name])
		@help_paginate = @pagin.length
		if @help_paginate.to_i <= (params[:per_page].to_i * (params[:page].to_i - 1)) then params[:page] = 1 end
		
		@users = User.paginate  	:per_page => params[:per_page],
															:order => params[:sort],
															:page => params[:page],
															:conditions => ["users.name iLIKE ?", searched_name]
		@count=@users.total_entries

		if request.xml_http_request?						
			render :partial => "userlist" 
		end
	end

	def new
		@user = User.new
	end
	
	def result
		unless params['search_name'].empty?
			searched_name = params['search_name']+'%'
			@result = User.find(:all, :conditions => ["name ilike ?", searched_name])
		else
			@result = User.all
		end
		#render :partial => "result", :collection => @result
	end

	def show
		if params[:page].to_i<1 then params[:page]=1 end
		if params[:per_page].to_i<1 
			unless session[:per_page].blank?
				params[:per_page] = session[:per_page]
			else params[:per_page] = 20
			end	
		end
		if params[:sort].nil? then params[:sort]="upper(changes.object_name)" end
		
		@changes = Change.paginate  :per_page => params[:per_page],
															:include => [:user],
															:order => params[:sort],
															:page => params[:page],
															:conditions => ['user_id=?', params[:id]]
		@authorchanges = Change.count(:conditions => [ "object_name iLIKE ? AND user_id=?", "authors", params[:id]])
		@receptionchanges = Change.count(:conditions => [ "object_name iLIKE ? AND user_id=?", "receptions", params[:id]])
		@workchanges = Change.count(:conditions => [ "object_name iLIKE ? AND user_id=?", "works", params[:id]])
	end

  def update
	@user.level = params[:user][:level] if admin?
		if @user.update_attributes(params[:user])
			log_change('update', 1, @user)
			flash[:notice] = 'User successfully updated.'
			redirect_to :action=> "show",:id=>@user.id
		else
			render :action=> "edit"
		end
	end

	private
	def find_user
		@user=User.find(params[:id])
	end
	
	def confirm_user_owns_record
		return if admin?
		if @user.id != @current_user.id
			redirect_to :action=> "show", :id => @current_user.id
		end
	end
	
	def admin_view
		unless logged_in?
			redirect_to(:controller => 'sessions', :action => 'new')
		else unless admin? 
			redirect_to(:controller => 'users', :action => 'show', :id => @current_user.id)
			end
		end

	end
	
end
