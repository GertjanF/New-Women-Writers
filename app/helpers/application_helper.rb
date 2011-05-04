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

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def admin?
		logged_in? && @current_user.level == 1
	end
	
	def delete_button(subject, subjectname)
  	link_to image_tag("delete.png", :border=>0),{:action => 'destroy', :id => subject.id}, :title => "delete this "+ subjectname, 
  		:confirm => "This will delete this "+ subjectname +".\n WARNING: All data belonging to this "+subjectname+" will be permanently deleted! \nAre you sure?",
  		:method => :delete 
	end

	def edit_button(subject, subjectname)
		link_to image_tag("edit.png", :border=>0),{:action => "edit", :id => subject.id},  :title => "edit this "+ subjectname
	end
	
	def editor?
		logged_in? && @current_user.level == 2 or logged_in? && @current_user.level == 1
	end

	def flash_notice
		if flash[:notice]
			content_tag('div', h(flash[:notice]), {:id => "flash_notice", :class=>"message"})
		end
	end

	def logged_in?
		@current_user.is_a?(User)
	end
	
		def no_records(things)
		content_tag('div', "No records found", {:id => "no_records", :class=>"message"}) if things.empty?
	end
	
	def sort_link_helper(list,text, field)
		field += " DESC" if params[:sort] == field
		link_to_function text, "document.getElementById('sort').value='"+field+"'; document.formnaam.submit()"
	end

	def sort_td_class_helper(field)
		result = 'class="sortup"' if params[:sort] == field
		result = 'class="sortdown"' if params[:sort] == field + " DESC"
		result = 'class="columnheader"'
		return result
	end

	def navigation (subject, searchby_text)
		result=hidden_field_tag('per_page', params[:per_page]) + "\n"
		result+=hidden_field_tag('sort', params[:sort])+ "\n"
		result+=hidden_field_tag('page', params[:page])+ "\n"
		
		result+="<div>\n"
		result+="<legend>Search by #{searchby_text}</legend>\n"
		result+= text_field_tag(:search_name, params[:search_name], :onblur=>'document.formnaam.submit()' )+ "\n"
		result+= image_submit_tag("search.png", :title=>"search")+ "\n"
		result+= link_to image_tag("reload.png", :title=>"show all")

		result+="</div>\n"

		result+="<div class=\"recsfound\">\n"
		result+="Found #{@count} records, \n"
		result+= text_field_tag(:per_page, params[:per_page], :size => 2, :onblur=>'document.formnaam.submit()' )+ "\n"
		result+="per page\n"
		result+="</div>\n"

		return result
	end
	
	def sorting_lists
		result="<form name='formnaam'>"
		result+=hidden_field_tag('sort', params[:sort])+ "\n"
		result+="</form>"

		return result
	end

=begin
		observe_field(:search_name, 
					:frequency => 0.50, 
					:before => "Element.show('spinner')",
					:success => "Element.hide('spinner')",
					:update =>:authors_list, 
					:url => { :action => :index }, 
					:with => "'search_name=' +value")

		image_tag("ajax-loader.gif",
              :align => "absmiddle",
              :border => 0,
              :id => "spinner",
              :style =>"display: none;" )
=end

	def one_to_many_helper(this_collection, name_collection, attribute, backtodestination)
		output="<table>"
		this_collection.each do |one| 
			output+="<tr id=\""+name_collection+"_"+one.id.to_s+"\">"
			output+="<td>"
			output+=link_to_function image_tag("xxcancel.png", :border=>0), "deleteOneFromMany('#{name_collection}', #{one.id.to_s})"
			output+="</td>"
			output+="<td>"
			output+=one.send(attribute)
			output+="</td>"
			output+="</tr>"
		end
		output+="</table>"
		output+='<div><input type="text" name="'+name_collection+'[]['+attribute+']" /></div>'
		output+= link_to_function image_tag("xxadd.png", :border=>0)+"add this #{name_collection.singularize}" , "addOneToMany('"+backtodestination+"')" 
		return output
	end
	
	# Used to make inputfields for author url, work url or reception url
	def one_to_many_link_helper(this_collection, name_collection, attribute1, attribute2, backtodestination)
		output="<table>"
		this_collection.each do |one| 
			output+="<tr id=\""+name_collection+"_"+one.id.to_s+"\">"
			output+="<td>"
			output+=link_to_function image_tag("xxcancel.png", :border=>0), "deleteOneFromMany('#{name_collection}', #{one.id.to_s})"
			output+="</td>"
			output+="<td>"
			output+=one.send(attribute1)+" - "+one.send(attribute2)
			output+="</td>"
			output+="</tr>"
		end
		output+="</table>"
		output+='<div>Title: <input type="text" name="'+name_collection+'[]['+attribute1+']" />'
		output+=' Url:   <input type="text" name="'+name_collection+'[]['+attribute2+']" /></div>'
		output+= link_to_function image_tag("xxadd.png", :border=>0)+"add this weblink" , "addOneToMany('"+backtodestination+"')" 
		return output
	end
	
	def approved?(object_name, object_id)
		@unapproved = Change.find(:all, :conditions => { :approved => 0, :object_name => object_name, :object_id => object_id})
		@unapproved.blank?
	end

	def cut_at(string, maxlength)
		if(string.length>maxlength) then
			string=string[0..maxlength-3]+"..."
		end
		return string
	end
	

=begin
	def sort_link_helper_old(list,text, field)
		key = field
		key += " DESC" if params[:sort] == field
		options = {
			:url => {:action => 'index', :params => params.merge({:sort => key, :page => nil})},
			:update => list,
			:before => "Element.hide('spinner')",
			:success => "Element.hide('spinner')"
		}

		html_options = {
			:title => "Sort by this field",
			:href => url_for(:action => 'index', :params => params.merge({:sort => key, :page => nil}))
		}
	
		link_to_remote(text, options, html_options)
	end
=end

end
