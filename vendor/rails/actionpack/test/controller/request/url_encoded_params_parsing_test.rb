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

class UrlEncodedParamsParsingTest < ActionController::IntegrationTest
  class TestController < ActionController::Base
    class << self
      attr_accessor :last_request_parameters, :last_request_type
    end

    def parse
      self.class.last_request_parameters = request.request_parameters
      head :ok
    end
  end

  def teardown
    TestController.last_request_parameters = nil
  end

  test "parses unbalanced query string with array" do
    assert_parses(
       {'location' => ["1", "2"], 'age_group' => ["2"]},
      "location[]=1&location[]=2&age_group[]=2"
    )
  end

  test "parses nested hash" do
    query = [
      "note[viewers][viewer][][type]=User",
      "note[viewers][viewer][][id]=1",
      "note[viewers][viewer][][type]=Group",
      "note[viewers][viewer][][id]=2"
    ].join("&")

    expected = { "note" => { "viewers"=>{"viewer"=>[{ "id"=>"1", "type"=>"User"}, {"type"=>"Group", "id"=>"2"} ]} } }
    assert_parses(expected, query)
  end

  test "parses more complex nesting" do
    query = [
      "customers[boston][first][name]=David",
      "customers[boston][first][url]=http://David",
      "customers[boston][second][name]=Allan",
      "customers[boston][second][url]=http://Allan",
      "something_else=blah",
      "something_nil=",
      "something_empty=",
      "products[first]=Apple Computer",
      "products[second]=Pc",
      "=Save"
    ].join("&")

    expected =  {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David",
            "url" => "http://David"
          },
          "second" => {
            "name" => "Allan",
            "url" => "http://Allan"
          }
        }
      },
      "something_else" => "blah",
      "something_empty" => "",
      "something_nil" => "",
      "products" => {
        "first" => "Apple Computer",
        "second" => "Pc"
      }
    }

    assert_parses expected, query
  end

  test "parses params with array" do
    query = "selected[]=1&selected[]=2&selected[]=3"
    expected = { "selected" => [ "1", "2", "3" ] }
    assert_parses expected, query
  end

  test "parses params with nil key" do
    query    = "=&test2=value1"
    expected = { "test2" => "value1" }
    assert_parses expected, query
  end

  test "parses params with array prefix and hashes" do
    query    = "a[][b][c]=d"
    expected = {"a" => [{"b" => {"c" => "d"}}]}
    assert_parses expected, query
  end

  test "parses params with complex nesting" do
    query    = "a[][b][c][][d][]=e"
    expected = {"a" => [{"b" => {"c" => [{"d" => ["e"]}]}}]}
    assert_parses expected, query
  end

  test "parses params with file path" do
    query = [
      "customers[boston][first][name]=David",
      "something_else=blah",
      "logo=#{File.expand_path(__FILE__)}"
    ].join("&")

    expected = {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David"
          }
        }
      },
      "something_else" => "blah",
      "logo" => File.expand_path(__FILE__),
    }

    assert_parses expected, query
  end

  test "parses params with Safari 2 trailing null character" do
    query = "selected[]=1&selected[]=2&selected[]=3\0"
    expected = { "selected" => [ "1", "2", "3" ] }
    assert_parses expected, query
  end

  private
    def with_test_routing
      with_routing do |set|
        set.draw do |map|
          map.connect ':action', :controller => "url_encoded_params_parsing_test/test"
        end
        yield
      end
    end

    def assert_parses(expected, actual)
      with_test_routing do
        post "/parse", actual
        assert_response :ok
        assert_equal(expected, TestController.last_request_parameters)
      end
    end
end
