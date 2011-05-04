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

module AuthorsHelper

	def relation_edit_helper(author)
	
		output="<table>"
		author.get_relations.each do |relation_id, relation|		# in author model
			output+="<tr id=\"relations_"+relation_id.to_s+"\">"
			output+="<td>"
			output+=link_to_function image_tag("xxcancel.png", :border=>0), "deleteOneFromMany('relations', #{relation_id})"
			output+="</td>"
			output+="<td>"
			output+=relation
			output+="</td>"
			output+="</tr>"
		end
		
		output+="</table>"
		output+="<div>"
		output+="Relation: "
		output+=select_tag "relation[type]", options_for_select(author.get_types.invert.sort)
		output+=" of "
		output+=collection_select(:relation, :id, Author.find(:all, :order=>'name'), :id, :name, {:include_blank => true}, {:class =>"wideselect"})
		output+="</div>"
		output+= link_to_function image_tag("xxadd.png", :border=>0)+" add this relation" , "addOneToMany('author')" 
		return output
	end

end
