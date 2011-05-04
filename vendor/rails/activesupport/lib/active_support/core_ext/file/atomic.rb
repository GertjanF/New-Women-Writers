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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module File #:nodoc:
      module Atomic
        # Write to a file atomically.  Useful for situations where you don't
        # want other processes or threads to see half-written files.
        #
        #   File.atomic_write("important.file") do |file|
        #     file.write("hello")
        #   end
        #
        # If your temp directory is not on the same filesystem as the file you're 
        # trying to write, you can provide a different temporary directory.
        # 
        #   File.atomic_write("/data/something.important", "/data/tmp") do |f|
        #     file.write("hello")
        #   end
        def atomic_write(file_name, temp_dir = Dir.tmpdir)
          require 'tempfile' unless defined?(Tempfile)

          temp_file = Tempfile.new(basename(file_name), temp_dir)
          yield temp_file
          temp_file.close

          begin
            # Get original file permissions
            old_stat = stat(file_name)
          rescue Errno::ENOENT
            # No old permissions, write a temp file to determine the defaults
            check_name = join(dirname(file_name), ".permissions_check.#{Thread.current.object_id}.#{Process.pid}.#{rand(1000000)}")
            open(check_name, "w") { }
            old_stat = stat(check_name)
            unlink(check_name)
          end

          # Overwrite original file with temp file
          rename(temp_file.path, file_name)

          # Set correct permissions on new file
          chown(old_stat.uid, old_stat.gid, file_name)
          chmod(old_stat.mode, file_name)
        end
      end
    end
  end
end
