# frozen_string_literal: true

module DeepL
  module Requests
    class Languages < Base
      def initialize(api, options = {})
        # options[:type] = "target"
        #puts "initialize languages #{options.inspect}"

        super(api, options)
      end

      def request
        puts "request languages "

        build_languages(*get)
      end

      private

      def build_languages(request, response)
        data = JSON.parse(response.body)
        data.map do |language|
          Resources::Language.new(language["language"], language["name"], language["supports_formality"], request, response)
        end
      end

      def path
        "languages"
      end
    end
  end
end
