# frozen_string_literal: true

module DeepL
  module Resources
    class Language < Base
<<<<<<< HEAD
      attr_reader :code, :name, :formality

      def initialize(code, name, formality, *args)
        super(*args)
        @code = code
        @name = name
        @formality = formality
      end

      def to_s
        "#{code} - #{name} (#{formality})"
=======
      attr_reader :code, :name

      def initialize(code, name, supports_formality, *args)
        super(*args)

        @code = code
        @name = name
        @supports_formality = supports_formality
      end

      def to_s
        "#{code} - #{name}"
      end

      def supports_formality?
        return @supports_formality unless @supports_formality.nil?

        raise Exceptions::NotSupported, 'Support formality is only available on target languages'
>>>>>>> bfcbbba5cf73fd7e3d64a1c28cdfe626e38c1f7e
      end
    end
  end
end
