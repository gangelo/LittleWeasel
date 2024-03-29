# frozen_string_literal: true

require 'factory_bot'
require_relative 'file_helpers'

FactoryBot::SyntaxRunner.include Support::FileHelpers

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
