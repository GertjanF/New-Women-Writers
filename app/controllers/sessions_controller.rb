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

class SessionsController < ApplicationController

	def create
		@current_user = User.authenticate(params[:username], params[:password])
		if @current_user
			session[:user] = @current_user.id
			redirect_to :controller => "users", :action=> "show", :id => @current_user.id
		else
			flash[:notice] = "No user was found with this username/password"
			render :action => 'new'
		end
	end
	
	def destroy
		reset_session
		flash[:notice] = "Logged out successfully"
		redirect_to :action => "new"
	end

  def reset_password
    if (!params[:email].nil?)
      @registered_user = User.registered?(params[:email])
      if @registered_user
        password = @registered_user.generate_new_password
        flash[:notice] = "A new password was sent to your address."
        render :action => 'new'      
      else
        flash[:notice] = "There is no known user with this address."
        render :action => 'reset_password'
      end
    end
  end	
		
	def new
	end
  
end
