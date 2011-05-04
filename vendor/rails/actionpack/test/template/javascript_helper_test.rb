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

require 'abstract_unit'

class JavaScriptHelperTest < ActionView::TestCase
  tests ActionView::Helpers::JavaScriptHelper

  attr_accessor :template_format, :output_buffer

  def setup
    @template = self
  end

  def test_escape_javascript
    assert_equal '', escape_javascript(nil)
    assert_equal %(This \\"thing\\" is really\\n netos\\'), escape_javascript(%(This "thing" is really\n netos'))
    assert_equal %(backslash\\\\test), escape_javascript( %(backslash\\test) )
    assert_equal %(dont <\\/close> tags), escape_javascript(%(dont </close> tags))
  end

  def test_link_to_function
    assert_dom_equal %(<a href="#" onclick="alert('Hello world!'); return false;">Greeting</a>),
      link_to_function("Greeting", "alert('Hello world!')")
  end

  def test_link_to_function_with_existing_onclick
    assert_dom_equal %(<a href="#" onclick="confirm('Sanity!'); alert('Hello world!'); return false;">Greeting</a>),
      link_to_function("Greeting", "alert('Hello world!')", :onclick => "confirm('Sanity!')")
  end

  def test_link_to_function_with_rjs_block
    html = link_to_function( "Greet me!" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<a href="#" onclick="Element.update(&quot;header&quot;, &quot;\\u003Ch1\\u003EGreetings\\u003C/h1\\u003E&quot;);; return false;">Greet me!</a>), html
  end

  def test_link_to_function_with_rjs_block_and_options
    html = link_to_function( "Greet me!", :class => "updater" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<a href="#" class="updater" onclick="Element.update(&quot;header&quot;, &quot;\\u003Ch1\\u003EGreetings\\u003C/h1\\u003E&quot;);; return false;">Greet me!</a>), html
  end

  def test_link_to_function_with_href
    assert_dom_equal %(<a href="http://example.com/" onclick="alert('Hello world!'); return false;">Greeting</a>),
      link_to_function("Greeting", "alert('Hello world!')", :href => 'http://example.com/')
  end

  def test_button_to_function
    assert_dom_equal %(<input type="button" onclick="alert('Hello world!');" value="Greeting" />),
      button_to_function("Greeting", "alert('Hello world!')")
  end

  def test_button_to_function_with_rjs_block
    html = button_to_function( "Greet me!" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<input type="button" onclick="Element.update(&quot;header&quot;, &quot;\\u003Ch1\\u003EGreetings\\u003C/h1\\u003E&quot;);;" value="Greet me!" />), html
  end

  def test_button_to_function_with_rjs_block_and_options
    html = button_to_function( "Greet me!", :class => "greeter" ) do |page|
      page.replace_html 'header', "<h1>Greetings</h1>"
    end
    assert_dom_equal %(<input type="button" class="greeter" onclick="Element.update(&quot;header&quot;, &quot;\\u003Ch1\\u003EGreetings\\u003C\/h1\\u003E&quot;);;" value="Greet me!" />), html
  end

  def test_button_to_function_with_onclick
    assert_dom_equal "<input onclick=\"alert('Goodbye World :('); alert('Hello world!');\" type=\"button\" value=\"Greeting\" />",
      button_to_function("Greeting", "alert('Hello world!')", :onclick => "alert('Goodbye World :(')")
  end

  def test_button_to_function_without_function
    assert_dom_equal "<input onclick=\";\" type=\"button\" value=\"Greeting\" />",
      button_to_function("Greeting")
  end

  def test_javascript_tag
    self.output_buffer = 'foo'

    assert_dom_equal "<script type=\"text/javascript\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>",
      javascript_tag("alert('hello')")

    assert_equal 'foo', output_buffer, 'javascript_tag without a block should not concat to output_buffer'
  end

  def test_javascript_tag_with_options
    assert_dom_equal "<script id=\"the_js_tag\" type=\"text/javascript\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>",
      javascript_tag("alert('hello')", :id => "the_js_tag")
  end

  def test_javascript_tag_with_block_in_erb
    __in_erb_template = ''
    javascript_tag { concat "alert('hello')" }
    assert_dom_equal "<script type=\"text/javascript\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", output_buffer
  end

  def test_javascript_tag_with_block_and_options_in_erb
    __in_erb_template = ''
    javascript_tag(:id => "the_js_tag") { concat "alert('hello')" }
    assert_dom_equal "<script id=\"the_js_tag\" type=\"text/javascript\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>", output_buffer
  end

  def test_javascript_cdata_section
    assert_dom_equal "\n//<![CDATA[\nalert('hello')\n//]]>\n", javascript_cdata_section("alert('hello')")
  end
end
