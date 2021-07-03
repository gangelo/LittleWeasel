# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

Dir[File.join('.', 'lib/LittleWeasel/**/*.rb')].each do |f|
  require f
end
