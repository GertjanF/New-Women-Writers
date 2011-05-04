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

module ActionView #:nodoc:
  module Helpers #:nodoc:
    autoload :ActiveRecordHelper, 'action_view/helpers/active_record_helper'
    autoload :AssetTagHelper, 'action_view/helpers/asset_tag_helper'
    autoload :AtomFeedHelper, 'action_view/helpers/atom_feed_helper'
    autoload :BenchmarkHelper, 'action_view/helpers/benchmark_helper'
    autoload :CacheHelper, 'action_view/helpers/cache_helper'
    autoload :CaptureHelper, 'action_view/helpers/capture_helper'
    autoload :DateHelper, 'action_view/helpers/date_helper'
    autoload :DebugHelper, 'action_view/helpers/debug_helper'
    autoload :FormHelper, 'action_view/helpers/form_helper'
    autoload :FormOptionsHelper, 'action_view/helpers/form_options_helper'
    autoload :FormTagHelper, 'action_view/helpers/form_tag_helper'
    autoload :JavaScriptHelper, 'action_view/helpers/javascript_helper'
    autoload :NumberHelper, 'action_view/helpers/number_helper'
    autoload :PrototypeHelper, 'action_view/helpers/prototype_helper'
    autoload :RecordIdentificationHelper, 'action_view/helpers/record_identification_helper'
    autoload :RecordTagHelper, 'action_view/helpers/record_tag_helper'
    autoload :SanitizeHelper, 'action_view/helpers/sanitize_helper'
    autoload :ScriptaculousHelper, 'action_view/helpers/scriptaculous_helper'
    autoload :TagHelper, 'action_view/helpers/tag_helper'
    autoload :TextHelper, 'action_view/helpers/text_helper'
    autoload :TranslationHelper, 'action_view/helpers/translation_helper'
    autoload :UrlHelper, 'action_view/helpers/url_helper'

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include SanitizeHelper::ClassMethods
    end

    include ActiveRecordHelper
    include AssetTagHelper
    include AtomFeedHelper
    include BenchmarkHelper
    include CacheHelper
    include CaptureHelper
    include DateHelper
    include DebugHelper
    include FormHelper
    include FormOptionsHelper
    include FormTagHelper
    include JavaScriptHelper
    include NumberHelper
    include PrototypeHelper
    include RecordIdentificationHelper
    include RecordTagHelper
    include SanitizeHelper
    include ScriptaculousHelper
    include TagHelper
    include TextHelper
    include TranslationHelper
    include UrlHelper
  end
end
