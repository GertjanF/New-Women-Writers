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

class << Object; alias_method :const_available?, :const_defined?; end
  
class ContentController < Class.new(ActionController::Base)
end
class NotAController
end
module Admin
  class << self; alias_method :const_available?, :const_defined?; end
  class UserController < Class.new(ActionController::Base); end
  class NewsFeedController < Class.new(ActionController::Base); end
end

# For speed test
class SpeedController < ActionController::Base;  end
class SearchController        < SpeedController; end
class VideosController        < SpeedController; end
class VideoFileController     < SpeedController; end
class VideoSharesController   < SpeedController; end
class VideoAbusesController   < SpeedController; end
class VideoUploadsController  < SpeedController; end
class VideoVisitsController   < SpeedController; end
class UsersController         < SpeedController; end
class SettingsController      < SpeedController; end
class ChannelsController      < SpeedController; end
class ChannelVideosController < SpeedController; end
class SessionsController      < SpeedController; end
class LostPasswordsController < SpeedController; end
class PagesController         < SpeedController; end

ActionController::Routing::Routes.draw do |map|
  map.route_one 'route_one', :controller => 'elsewhere', :action => 'flash_me'
  map.connect ':controller/:action/:id'
end
