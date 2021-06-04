# frozen_string_literal: true

module LittleWeasel
  module Errors
    # This class describes an error when a dictionary is already loaded and
    # should not be loaded again.
    class DictionaryFileAlreadyLoadedError < StandardError; end
  end
end
