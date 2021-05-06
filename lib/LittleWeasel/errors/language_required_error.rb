# frozen_string_literal: true

module LittleWeasel
  module Errors
    # Describes an error when a language is required
    # but was missing
    class LanguageRequiredError < StandardError; end
  end
end
