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

require 'active_resource/connection'

module ActiveResource
  class InvalidRequestError < StandardError; end #:nodoc:

  # One thing that has always been a pain with remote web services is testing.  The HttpMock
  # class makes it easy to test your Active Resource models by creating a set of mock responses to specific
  # requests.
  #
  # To test your Active Resource model, you simply call the ActiveResource::HttpMock.respond_to
  # method with an attached block.  The block declares a set of URIs with expected input, and the output
  # each request should return.  The passed in block has any number of entries in the following generalized
  # format:
  #
  #   mock.http_method(path, request_headers = {}, body = nil, status = 200, response_headers = {})
  #
  # * <tt>http_method</tt> - The HTTP method to listen for.  This can be +get+, +post+, +put+, +delete+ or
  #   +head+.
  # * <tt>path</tt> - A string, starting with a "/", defining the URI that is expected to be
  #   called.
  # * <tt>request_headers</tt> - Headers that are expected along with the request.  This argument uses a
  #   hash format, such as <tt>{ "Content-Type" => "application/xml" }</tt>.  This mock will only trigger
  #   if your tests sends a request with identical headers.
  # * <tt>body</tt> - The data to be returned.  This should be a string of Active Resource parseable content,
  #   such as XML.
  # * <tt>status</tt> - The HTTP response code, as an integer, to return with the response.
  # * <tt>response_headers</tt> - Headers to be returned with the response.  Uses the same hash format as
  #   <tt>request_headers</tt> listed above.
  #
  # In order for a mock to deliver its content, the incoming request must match by the <tt>http_method</tt>,
  # +path+ and <tt>request_headers</tt>.  If no match is found an InvalidRequestError exception
  # will be raised letting you know you need to create a new mock for that request.
  #
  # ==== Example
  #   def setup
  #     @matz  = { :id => 1, :name => "Matz" }.to_xml(:root => "person")
  #     ActiveResource::HttpMock.respond_to do |mock|
  #       mock.post   "/people.xml",   {}, @matz, 201, "Location" => "/people/1.xml"
  #       mock.get    "/people/1.xml", {}, @matz
  #       mock.put    "/people/1.xml", {}, nil, 204
  #       mock.delete "/people/1.xml", {}, nil, 200
  #     end
  #   end
  #   
  #   def test_get_matz
  #     person = Person.find(1)
  #     assert_equal "Matz", person.name
  #   end
  #
  class HttpMock
    class Responder #:nodoc:
      def initialize(responses)
        @responses = responses
      end

      for method in [ :post, :put, :get, :delete, :head ]
        # def post(path, request_headers = {}, body = nil, status = 200, response_headers = {})
        #   @responses[Request.new(:post, path, nil, request_headers)] = Response.new(body || "", status, response_headers)
        # end
        module_eval <<-EOE, __FILE__, __LINE__
          def #{method}(path, request_headers = {}, body = nil, status = 200, response_headers = {})
            @responses << [Request.new(:#{method}, path, nil, request_headers), Response.new(body || "", status, response_headers)]
          end
        EOE
      end
    end

    class << self

      # Returns an array of all request objects that have been sent to the mock.  You can use this to check
      # if your model actually sent an HTTP request.
      #
      # ==== Example
      #   def setup
      #     @matz  = { :id => 1, :name => "Matz" }.to_xml(:root => "person")
      #     ActiveResource::HttpMock.respond_to do |mock|
      #       mock.get "/people/1.xml", {}, @matz
      #     end
      #   end
      #   
      #   def test_should_request_remote_service
      #     person = Person.find(1)  # Call the remote service
      #     
      #     # This request object has the same HTTP method and path as declared by the mock
      #     expected_request = ActiveResource::Request.new(:get, "/people/1.xml")
      #     
      #     # Assert that the mock received, and responded to, the expected request from the model
      #     assert ActiveResource::HttpMock.requests.include?(expected_request)
      #   end
      def requests
        @@requests ||= []
      end

      # Returns the list of requests and their mocked responses. Look up a
      # response for a request using responses.assoc(request).
      def responses
        @@responses ||= []
      end

      # Accepts a block which declares a set of requests and responses for the HttpMock to respond to. See the main
      # ActiveResource::HttpMock description for a more detailed explanation.
      def respond_to(pairs = {}) #:yields: mock
        reset!
        responses.concat pairs.to_a
        if block_given?
          yield Responder.new(responses)
        else
          Responder.new(responses)
        end
      end

      # Deletes all logged requests and responses.
      def reset!
        requests.clear
        responses.clear
      end
    end

    # body?       methods
    { true  => %w(post put),
      false => %w(get delete head) }.each do |has_body, methods|
      methods.each do |method|
        # def post(path, body, headers)
        #   request = ActiveResource::Request.new(:post, path, body, headers)
        #   self.class.requests << request
        #   self.class.responses.assoc(request).try(:second) || raise(InvalidRequestError.new("No response recorded for #{request}"))
        # end
        module_eval <<-EOE, __FILE__, __LINE__
          def #{method}(path, #{'body, ' if has_body}headers)
            request = ActiveResource::Request.new(:#{method}, path, #{has_body ? 'body, ' : 'nil, '}headers)
            self.class.requests << request
            self.class.responses.assoc(request).try(:second) || raise(InvalidRequestError.new("No response recorded for \#{request}"))
          end
        EOE
      end
    end

    def initialize(site) #:nodoc:
      @site = site
    end
  end

  class Request
    attr_accessor :path, :method, :body, :headers

    def initialize(method, path, body = nil, headers = {})
      @method, @path, @body, @headers = method, path, body, headers.merge(ActiveResource::Connection::HTTP_FORMAT_HEADER_NAMES[method] => 'application/xml')
    end

    def ==(req)
      path == req.path && method == req.method && headers == req.headers
    end

    def to_s
      "<#{method.to_s.upcase}: #{path} [#{headers}] (#{body})>"
    end
  end

  class Response
    attr_accessor :body, :message, :code, :headers

    def initialize(body, message = 200, headers = {})
      @body, @message, @headers = body, message.to_s, headers
      @code = @message[0,3].to_i

      resp_cls = Net::HTTPResponse::CODE_TO_OBJ[@code.to_s]
      if resp_cls && !resp_cls.body_permitted?
        @body = nil
      end

      if @body.nil?
        self['Content-Length'] = "0"
      else
        self['Content-Length'] = body.size.to_s
      end
    end

    def success?
      (200..299).include?(code)
    end

    def [](key)
      headers[key]
    end

    def []=(key, value)
      headers[key] = value
    end

    def ==(other)
      if (other.is_a?(Response))
        other.body == body && other.message == message && other.headers == headers
      else
        false
      end
    end
  end

  class Connection
    private
      silence_warnings do
        def http
          @http ||= HttpMock.new(@site)
        end
      end
  end
end