# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to indicate dictionary sources.
    module DictionarySourceable
      MEMORY_SOURCE = 'memory'

      module_function

      def memory_source?(source)
        source == MEMORY_SOURCE
      end
    end
  end
end
