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

class Author < ActiveRecord::Base
	# associations
	has_many :author_urls, :dependent => :delete_all
	has_many :pseudonyms, :dependent => :delete_all
	has_many :receptions, :dependent => :destroy
	has_and_belongs_to_many :countries
	has_and_belongs_to_many :languages
	has_many :to_relations, 
	  :dependent => :delete_all,
		:class_name => 'Relation',
		:foreign_key => 'author_id'
	has_many :from_relations,
	  :dependent => :delete_all,
		:class_name => 'Relation',
		:foreign_key => 'relative_id'
	has_many :works, :dependent => :destroy
  has_many :changes, :as => :object 
	has_and_belongs_to_many :to_relatives,
    :class_name => 'Author',
		:join_table => 'relations',
		:association_foreign_key => 'relative_id',
		:foreign_key => 'author_id'
   has_and_belongs_to_many :from_relatives,
    :class_name => 'Author',
		:join_table => 'relations',
		:association_foreign_key => 'author_id',
		:foreign_key => 'relative_id'
   has_and_belongs_to_many :relation_types,
    :class_name => 'RelationType',
		:join_table => 'relations',
		:association_foreign_key => 'relation_type_id',
		:foreign_key => 'author_id'

#		:association_foreign_key => 'author_id',
#		:foreign_key => 'relation_type'


	# class methods
=begin
	validates_presence_of :name
	validates_presence_of :year_born
	validates_presence_of :year_death
	validates_inclusion_of :gender, :in=> %w( M F U)
	validates_inclusion_of :year_born, :in=> 1700..1900, :message => "should be between 1700 and 1900"
	validates_inclusion_of :year_death, :in=> 1700..1900, :message => "should be between 1700 and 1900"
=end
	
	
	def fullgender
		case gender
			when 'F': 'female'
			when 'M': 'male'
			else 'unknown'
		end
	end
	
	def self.all
		find(:all)
	end
	def self.women
		find(:all, :conditions => "gender = 'F' ", :order => "name")
	end
	def self.others
		find(:all, :conditions => "gender <> 'F' ", :order => "name")
	end
	
	def short_name
		name[0, 25]
	end

	# Returns hash with author id of relative=> relation discription and name of relative : e.g.  {"7"=>"Mother of Sand, Solange"} 7 is id of Solange
	def get_children
		if(gender=='M') : typefield='parent_male' else typefield='parent_female' end
		children={}
		self.to_relations.collect.each do |r|
			children.merge!(r.relative.id=>r.relation_type.send(typefield) +' of '+ r.relative.name)
		end
		return children
	end

	# Returns hash with author id of relative=> relation discription and name of relative : e.g.  {"6"=>"Daughter of Sand, George"}  6 is id of George
	def get_parents 
		if(gender=='M') : typefield='child_male' else typefield='child_female' end
		parents={}
		self.from_relations.collect.each do |r|
			parents.merge!(r.author.id => r.relation_type.send(typefield)  +' of '+  r.author.name)
		end
		return parents
	end

	def get_relations
		if(gender=='M')
			parentfield='parent_male' 
			childfield='child_male'
		else 
			parentfield='parent_female' 
			childfield='child_female'
		end
		relations={}
		self.to_relations.collect.each do |r|
			relations.merge!(r.id=>r.relation_type.send(parentfield) +' of '+ r.relative.name)
		end
		self.from_relations.collect.each do |r|
			relations.merge!(r.id => r.relation_type.send(childfield)  +' of '+  r.author.name)
		end
		return relations
	end

	def get_types
		if(gender=='M')
			parentfield='parent_male' 
			childfield='child_male'
		else 
			parentfield='parent_female' 
			childfield='child_female'
		end
		thistypes={}
		reltypes=RelationType.all
		reltypes.each do |r|
			thistypes.merge!(r.id=>r.send(parentfield))
			thistypes.merge!(r.id*100 => r.send(childfield))
		end

		return thistypes
	end


	
	def validate
#		errors.add('year_born', 'must be before year death') if year_born >= year_death
	end

end
