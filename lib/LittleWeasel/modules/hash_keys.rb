# frozen_string_literal: true

require_relative '../errors/language_required_error'

module LittleWeasel
  module Modules
    # Defines methods to support Dictionary Hash keys.
    module HashKeys
      HASH_KEY_SEPARATOR = '-'

      module_function

      # This method takes Hash keys that are expected to be String
      # types, and returns an Array whose elements represent the
      # Hash key tokens for language, region and tag. If a token
      # is not present in the Hash key, nil is returned in its place.
      # language and region are converted to lower and upper case
      # respectfully, while tag will remain unchanged.
      #
      # @example Example input along with the return value
      #
      #  'en-US-tag'
      #  #=> ['en', 'US', 'tag']
      #
      #  'en--'
      #  #=> ['en', nil, nil]
      #
      #  'en--tag'
      #  #=> ['en', nil, 'tag']
      #
      #  '--tag'
      #  #=> [nil, nil, 'tag']
      #
      #  'EN-us-TaG'
      #  #=> ['en', 'US', 'TaG']
      def split_key(hash_key)
        language, region, tag = hash_key.split(HASH_KEY_SEPARATOR).map { |token| token unless token.blank? }

        [language.downcase, region&.upcase || nil, tag || nil]
      end

      def split_key_to_hash(hash_key)
        language, region, tag = split_key hash_key
        { language: language, region: region, tag: tag }
      end

      def join_key(language:, region: nil, tag: nil)
        raise Errors::LanguageRequiredError unless language.present?

        "#{language.downcase}#{HASH_KEY_SEPARATOR}#{region&.upcase}#{HASH_KEY_SEPARATOR}#{tag}"
      end

      def language_key?(hash_key)
        language, region, _tag = split_to_bool hash_key
        language && !region
      end

      def region_key?(hash_key)
        language, region, _tag = split_to_bool hash_key
        language && region
      end

      def tagged_key?(hash_key)
        language, region, tag = split_to_bool hash_key
        tag && (language || region)
      end

      def split_to_bool(hash_key)
        language, region, tag = split_key(hash_key).map { |token| !token.blank? }
        [language, region || false, tag || false]
      end
    end
  end
end
