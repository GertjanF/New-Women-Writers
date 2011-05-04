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

class <%= controller_class_name %>Controller < ApplicationController
  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  def index
    @<%= table_name %> = <%= class_name %>.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= table_name %> }
    end
  end

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/new
  # GET /<%= table_name %>/new.xml
  def new
    @<%= file_name %> = <%= class_name %>.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  # POST /<%= table_name %>
  # POST /<%= table_name %>.xml
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to(@<%= file_name %>) }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to(@<%= file_name %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= table_name %>_url) }
      format.xml  { head :ok }
    end
  end
end
