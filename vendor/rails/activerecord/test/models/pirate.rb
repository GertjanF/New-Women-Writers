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

class Pirate < ActiveRecord::Base
  belongs_to :parrot
  has_and_belongs_to_many :parrots
  has_and_belongs_to_many :parrots_with_method_callbacks, :class_name => "Parrot",
    :before_add    => :log_before_add,
    :after_add     => :log_after_add,
    :before_remove => :log_before_remove,
    :after_remove  => :log_after_remove
  has_and_belongs_to_many :parrots_with_proc_callbacks, :class_name => "Parrot",
    :before_add    => proc {|p,pa| p.ship_log << "before_adding_proc_parrot_#{pa.id || '<new>'}"},
    :after_add     => proc {|p,pa| p.ship_log << "after_adding_proc_parrot_#{pa.id || '<new>'}"},
    :before_remove => proc {|p,pa| p.ship_log << "before_removing_proc_parrot_#{pa.id}"},
    :after_remove  => proc {|p,pa| p.ship_log << "after_removing_proc_parrot_#{pa.id}"}

  has_many :treasures, :as => :looter
  has_many :treasure_estimates, :through => :treasures, :source => :price_estimates

  # These both have :autosave enabled because accepts_nested_attributes_for is used on them.
  has_one :ship
  has_many :birds
  has_many :birds_with_method_callbacks, :class_name => "Bird",
    :before_add    => :log_before_add,
    :after_add     => :log_after_add,
    :before_remove => :log_before_remove,
    :after_remove  => :log_after_remove
  has_many :birds_with_proc_callbacks, :class_name => "Bird",
    :before_add     => proc {|p,b| p.ship_log << "before_adding_proc_bird_#{b.id || '<new>'}"},
    :after_add      => proc {|p,b| p.ship_log << "after_adding_proc_bird_#{b.id || '<new>'}"},
    :before_remove  => proc {|p,b| p.ship_log << "before_removing_proc_bird_#{b.id}"},
    :after_remove   => proc {|p,b| p.ship_log << "after_removing_proc_bird_#{b.id}"}

  accepts_nested_attributes_for :parrots, :birds, :allow_destroy => true, :reject_if => proc { |attributes| attributes.empty? }
  accepts_nested_attributes_for :ship, :allow_destroy => true, :reject_if => proc { |attributes| attributes.empty? }
  accepts_nested_attributes_for :parrots_with_method_callbacks, :parrots_with_proc_callbacks,
    :birds_with_method_callbacks, :birds_with_proc_callbacks, :allow_destroy => true

  validates_presence_of :catchphrase

  def ship_log
    @ship_log ||= []
  end

  private
    def log_before_add(record)
      log(record, "before_adding_method")
    end

    def log_after_add(record)
      log(record, "after_adding_method")
    end

    def log_before_remove(record)
      log(record, "before_removing_method")
    end

    def log_after_remove(record)
      log(record, "after_removing_method")
    end

    def log(record, callback)
      ship_log << "#{callback}_#{record.class.name.downcase}_#{record.id || '<new>'}"
    end
end
