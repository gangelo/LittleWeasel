# frozen_string_literal: true

module Support
  # Provides miscellaneous help methods for use in specs.
  module GeneralHelpers
    # For some reason, passing create(described_class) raises
    # a "KeyError: Factory not registered: LittleWeasel::Klass"
    # error where Klass == (for example) any Dictionary or
    # subclass. This creates a symbol from the class name that
    # factory_bot will like.

    # :reek:UtilityFunction - ignored, this is only spec support.
    def sym_for(klass)
      klass.name.demodulize.underscore.to_sym
    end
  end
end
