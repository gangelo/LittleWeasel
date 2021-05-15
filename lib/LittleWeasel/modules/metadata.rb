# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Modules
    # Defines methods to support Dictionary metadata
    module Metadata
      METADATA_ROOT_KEY = :'$$metadata$$'

      def self.included(base)
        base.extend ClassMethods
      end

      def metadata
        self.class.metadata_for dictionary_words_hash
      end

      def refresh!
        self.class.refresh_metadata! dictionary_words_hash
      end

      module ClassMethods
        def metadata_for(dictionary_words_hash)
          raise Errors::MustOverrideError
        end

        def refresh_metadata!(dictionary_words_hash)
          raise Errors::MustOverrideError
        end
      end
    end
  end
end
