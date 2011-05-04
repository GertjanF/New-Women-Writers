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

class HelpsController < ApplicationController
before_filter :admin_required, :only => [:index, :edit, :update, :show]
before_filter :help_finder, :except => [:index, :new, :create]

	def create
		@help = Help.new(params[:help])
			if @help.save
				#log_change('create', 0, @help)
				flash[:notice] = 'Help page successfully created.'
				redirect_to :action => "index"
			else
				render :action => "new"
			end
	end
	
	def edit
	end

	def index
		@helptexts = Help.find(:all)
	end
	
	def new
	end
	
	def show
	end
	
	def update
		if @help_page.update_attributes(params[:help])
			#log_change('update', 0, @help_page)
			flash[:notice] = 'Help page successfully updated.'
			redirect_to :action => "show", :id => params[:id]
		else
			render :action => "edit"
		end
	end
	
private

def help_finder
	@help_page = Help.find(params[:id])
end

end
