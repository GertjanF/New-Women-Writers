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

module MyApplication
  module Business
    class Company < ActiveRecord::Base
      attr_protected :rating
    end

    class Firm < Company
      has_many :clients, :order => "id", :dependent => :destroy
      has_many :clients_sorted_desc, :class_name => "Client", :order => "id DESC"
      has_many :clients_of_firm, :foreign_key => "client_of", :class_name => "Client", :order => "id"
      has_many :clients_like_ms, :conditions => "name = 'Microsoft'", :class_name => "Client", :order => "id"
      has_many :clients_using_sql, :class_name => "Client", :finder_sql => 'SELECT * FROM companies WHERE client_of = #{id}'

      has_one :account, :class_name => 'MyApplication::Billing::Account', :dependent => :destroy
    end

    class Client < Company
      belongs_to :firm, :foreign_key => "client_of"
      belongs_to :firm_with_other_name, :class_name => "Firm", :foreign_key => "client_of"

      class Contact < ActiveRecord::Base; end
    end

    class Developer < ActiveRecord::Base
      has_and_belongs_to_many :projects
      validates_length_of :name, :within => (3..20)
    end

    class Project < ActiveRecord::Base
      has_and_belongs_to_many :developers
    end

  end

  module Billing
    class Firm < ActiveRecord::Base
      self.table_name = 'companies'
    end

    module Nested
      class Firm < ActiveRecord::Base
        self.table_name = 'companies'
      end
    end

    class Account < ActiveRecord::Base
      with_options(:foreign_key => :firm_id) do |i|
        i.belongs_to :firm, :class_name => 'MyApplication::Business::Firm'
        i.belongs_to :qualified_billing_firm, :class_name => 'MyApplication::Billing::Firm'
        i.belongs_to :unqualified_billing_firm, :class_name => 'Firm'
        i.belongs_to :nested_qualified_billing_firm, :class_name => 'MyApplication::Billing::Nested::Firm'
        i.belongs_to :nested_unqualified_billing_firm, :class_name => 'Nested::Firm'
      end

      protected
        def validate
          errors.add_on_empty "credit_limit"
        end
    end
  end
end
