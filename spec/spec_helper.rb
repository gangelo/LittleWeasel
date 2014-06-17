require File.expand_path(File.dirname(__FILE__) + '../../lib/LittleWeasel')

# Use :should in stead of :expect
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
  config.mock_with :rspec do |c|
    c.syntax = :should
  end
  #config.raise_errors_for_deprecations!
end
