# frozen_string_literal: true

module LittleWeasel
  module Services
    class InvalidWordsMetadataService
      def initialize(dictionary)
        self.dictionary = dictionary
        self.current_bytesize = 0
      end

      def execute
        return build_return unless max_invalid_words_bytesize?

        self.current_bytesize = dictionary.reduce(0) do |bytesize, word_and_found|
          unless word_and_found.last
            bytesize += word_and_found.first.bytesize
            break unless bytesize < max_invalid_words_bytesize
          end
          bytesize
        end
        build_return
      end

      private

      attr_accessor :current_bytesize, :dictionary

      def build_return
        values = {
          max_invalid_words_bytesize?: max_invalid_words_bytesize?,
          current_invalid_word_bytesize: current_bytesize,
          max_invalid_words_bytesize: max_invalid_words_bytesize
        }
        return_struct_for(values.keys).new(*values.values)
      end

      def return_struct_for(keys)
        Struct.new(*keys) do
          def on?
            max_invalid_words_bytesize?
          end

          def off?
            !on?
          end

          def value
            max_invalid_words_bytesize
          end

          def value_exceeded?
            on? && current_invalid_word_bytesize > max_invalid_words_bytesize
          end

          def cache_invalid_words?
            on? && !value_exceeded?
          end
        end
      end

      def max_invalid_words_bytesize
        @max_invalid_words_bytesize ||= config.max_invalid_words_bytesize
      end

      def max_invalid_words_bytesize?
        config.max_invalid_words_bytesize?
      end

      def config
        @config ||= LittleWeasel.configuration
      end
    end
  end
end
