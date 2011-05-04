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

class Customer < ActiveRecord::Base
  composed_of :address, :mapping => [ %w(address_street street), %w(address_city city), %w(address_country country) ], :allow_nil => true
  composed_of :balance, :class_name => "Money", :mapping => %w(balance amount), :converter => Proc.new { |balance| balance.to_money }
  composed_of :gps_location, :allow_nil => true
  composed_of :fullname, :mapping => %w(name to_s), :constructor => Proc.new { |name| Fullname.parse(name) }, :converter => :parse
end

class Address
  attr_reader :street, :city, :country

  def initialize(street, city, country)
    @street, @city, @country = street, city, country
  end

  def close_to?(other_address)
    city == other_address.city && country == other_address.country
  end

  def ==(other)
    other.is_a?(self.class) && other.street == street && other.city == city && other.country == country
  end
end

class Money
  attr_reader :amount, :currency

  EXCHANGE_RATES = { "USD_TO_DKK" => 6, "DKK_TO_USD" => 0.6 }

  def initialize(amount, currency = "USD")
    @amount, @currency = amount, currency
  end

  def exchange_to(other_currency)
    Money.new((amount * EXCHANGE_RATES["#{currency}_TO_#{other_currency}"]).floor, other_currency)
  end
end

class GpsLocation
  attr_reader :gps_location

  def initialize(gps_location)
    @gps_location = gps_location
  end

  def latitude
    gps_location.split("x").first
  end

  def longitude
    gps_location.split("x").last
  end

  def ==(other)
    self.latitude == other.latitude && self.longitude == other.longitude
  end
end

class Fullname
  attr_reader :first, :last

  def self.parse(str)
    return nil unless str
    new(*str.to_s.split)
  end

  def initialize(first, last = nil)
    @first, @last = first, last
  end

  def to_s
    "#{first} #{last.upcase}"
  end
end