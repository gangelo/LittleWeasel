# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module simply includes ActiveSupport's core for #deep_dup support. If
    # we ever want to roll our own, we can do so here.
    module DeepDup
      require 'active_support/core_ext/object/deep_dup'
    end
  end
end
