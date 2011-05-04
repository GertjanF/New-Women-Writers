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

class RelationsController < ApplicationController
before_filter :editor_required, :except => [:index, :show]
before_filter :find_relation, :except => [:index, :new, :create]

  def create
  end

  def destroy
	@relation.destroy
  end

  def edit
  end

  def index
  end

  def new
  end

  def show
  end

  def update
  end

end

	private
	def find_relation
		@relation = Relation.find(params[:id])
	end
