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

class User < ActiveRecord::Base
	#associations
	has_many :changes, :dependent => :nullify
	
	#unencrypted password
	attr_accessor :password
	
	validates_confirmation_of :password, :if => :password_required?

	#Protectmethodfrommass-update
	attr_protected :level

	#callbacks
	before_save :encrypt_password

	#encrypts given password using salt
	def self.encrypt(pass, salt)
		Digest::SHA1.hexdigest("--#{salt}--#{pass}--")
	end
	
	#authenticate by username/password
	def self.authenticate(username, pass)
		user = find_by_username(username)
		user && user.authenticated?(pass)? user: nil
	end
	
	#registered emailaddress
  def self.registered?(email)
    user = find_by_email(email)
  end
	
	#does the given password match the stored encrypted password
	def authenticated?(pass)
		encrypted_password == User.encrypt(pass,salt)
	end

  #generate random new password
  def generate_new_password
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    password = ''
    10.times { password << chars[rand(chars.size)] }
    self.update_attributes(:encrypted_password => User.encrypt(password, self.salt))
    UserMailer.deliver_forgot_password_mail(self, password)
    password
  end
   	
	protected
	#before save - create salt, encrypt password
	
	def encrypt_password
		return if password.blank?
		if new_record?
			self.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{name}--")
		end
		self.encrypted_password = User.encrypt(password, salt)
	end

	#no encrypted password yet OR password attribute is set

	def password_required?
		encrypted_password.blank? || !password.blank?
	end

end
