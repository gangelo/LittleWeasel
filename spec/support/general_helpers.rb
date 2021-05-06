# frozen_string_literal: true

module Support
  # Provides miscellaneous help methods for use in specs.
  module GeneralHelpers
    # For some reason, passing create(described_class) raises
    # a "KeyError: Factory not registered: LittleWeasel::Klass"
    # error where Klass == (for example) any Dictionary or
    # subclass. This creates a symbol from the class name that
    # factory_bot will like.

    # disable :reek:UtilityFunction - ignored, this is only spec support.
    def sym_for(klass)
      klass.name.demodulize.underscore.to_sym
    end

    def hash_key_for(language, region = nil, tag = nil)
      LittleWeasel::Modules::HashKeys.join_key(language: language, region: region, tag: tag)
    end
  end
end
