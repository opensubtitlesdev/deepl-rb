# frozen_string_literal: true

module DeepL
  module Resources
    class Language < Base
      attr_reader :code, :name, :formality

      def initialize(code, name, formality, *args)
        super(*args)
        @code = code
        @name = name
        @formality = formality
      end

      def to_s
        "#{code} - #{name} (#{formality})"
      end
    end
  end
end
