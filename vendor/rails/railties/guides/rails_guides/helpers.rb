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

module RailsGuides
  module Helpers
    def guide(name, url, options = {}, &block)
      link = content_tag(:a, :href => url) { name }
      result = content_tag(:dt, link)

      if ticket = options[:ticket]
        result << content_tag(:dd, lh(ticket), :class => 'ticket')
      end

      result << content_tag(:dd, capture(&block))
      concat(result)
    end

    def lh(id, label = "Lighthouse Ticket")
      url = "http://rails.lighthouseapp.com/projects/16213/tickets/#{id}"
      content_tag(:a, label, :href => url)
    end

    def author(name, nick, image = 'credits_pic_blank.gif', &block)
      image = "images/#{image}"

      result = content_tag(:img, nil, :src => image, :class => 'left pic', :alt => name)
      result << content_tag(:h3, name)
      result << content_tag(:p, capture(&block))
      concat content_tag(:div, result, :class => 'clearfix', :id => nick)
    end

    def code(&block)
      c = capture(&block)
      content_tag(:code, c)
    end
  end
end
