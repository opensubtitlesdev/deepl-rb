# frozen_string_literal: true

module DeepL
  module Requests
    class Base
      API_VERSION = "v2".freeze

      attr_reader :api, :response, :options

      def initialize(api, options = {})
        @api = api
        @options = options
      end

      def request
        raise NotImplementedError
      end

      private

      def option?(name)
        options.key?(name.to_s) || options.key?(name.to_sym)
      end #

      def option(name)
        options[name.to_s] || options[name.to_sym]
      end

      def set_option(name, value)
        if options.key?(name.to_sym)
          options[name.to_sym] = value
        else
          options[name.to_s] = value
        end
      end

      def post(payload)
        puts "post payload ! #{uri.request_uri}"
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(payload.compact)
        response = http.request(request)

        validate_response!(request, response)
        [request, response]
      end

      def get
        myuri = uri.request_uri
        # puts "myuri params in get: #{myuri}"
        request = Net::HTTP::Get.new(myuri)
        response = http.request(request)

        validate_response!(request, response)
        [request, response]
      end

      def http
        @http ||= begin
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == "https"
            http
          end
      end

      def validate_response!(request, response)
        return if response.is_a?(Net::HTTPSuccess)

        case response.code
        when "400" then raise Exceptions::BadRequest.new(request, response)
        when "403" then raise Exceptions::AuthorizationFailed.new(request, response)
        when "429" then raise Exceptions::LimitExceeded.new(request, response)
        when "456" then raise Exceptions::QuotaExceeded.new(request, response)
        else raise Exceptions::RequestError.new(request, response)
        end
      end

      def path
        raise NotImplementedError
      end

      def url
        "#{host}/#{api.configuration.version}/#{path}"
      end

      def uri
        @uri ||= begin
            uri = URI(url)
            new_query = URI.decode_www_form(uri.query || "") + query_params.to_a
            uri.query = URI.encode_www_form(new_query)
            uri
          end
      end

      def host
        api.configuration.host
      end

      def query_params
        # puts "query params in base #{options}"
        { auth_key: api.configuration.auth_key }.merge(options)
      end
    end
  end
end
