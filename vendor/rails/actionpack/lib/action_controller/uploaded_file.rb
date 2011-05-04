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

module ActionController
  module UploadedFile
    def self.included(base)
      base.class_eval do
        attr_accessor :original_path, :content_type
        alias_method :local_path, :path
      end
    end

    def self.extended(object)
      object.class_eval do
        attr_accessor :original_path, :content_type
        alias_method :local_path, :path
      end
    end

    # Take the basename of the upload's original filename.
    # This handles the full Windows paths given by Internet Explorer
    # (and perhaps other broken user agents) without affecting
    # those which give the lone filename.
    # The Windows regexp is adapted from Perl's File::Basename.
    def original_filename
      unless defined? @original_filename
        @original_filename =
          unless original_path.blank?
            if original_path =~ /^(?:.*[:\\\/])?(.*)/m
              $1
            else
              File.basename original_path
            end
          end
      end
      @original_filename
    end
  end

  class UploadedStringIO < StringIO
    include UploadedFile
  end

  class UploadedTempfile < Tempfile
    include UploadedFile
  end
end
