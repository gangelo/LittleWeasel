# frozen_string_literal: true

require 'securerandom'

module LittleWeasel
  module Modules
    # This module provides methods to manage dictionary sources.
    module DictionarySourceable
      MEMORY_SOURCE = '*'

      module_function

      def file_source?(source)
        !memory_source? source
      end

      def memory_source?(source)
        source =~ /^#{Regexp.quote(MEMORY_SOURCE)}[0-9a-fA-F]{8}$/
      end

      def memory_source
        "#{MEMORY_SOURCE}#{SecureRandom.uuid[0..7]}"
      end
    end
  end
end
