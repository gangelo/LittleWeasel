# frozen_string_literal: true

module LittleWeasel
  module Modules
    module MaxInvalidWordsByteSizeCacheable
      def [](word)
        _cached, found = cache_word_if! word
        found
      end

      private

      def cache_word_if!(word)
        return [true, true] if word_found? word
binding.pry
        cache = cache_word? word
        if cache
          dictionary[word] = false
          metadata.current_invalid_word_bytesize += word.bytesize
        end

        [cache, false]
      end

      def cache_word?(word)
        return true if word_found?(word)

        #metadata = max_invalid_words_bytesize_metadata
        return false unless metadata.cache_invalid_words?

        metadata.value > (word.bytesize + metadata.current_invalid_word_bytesize)
      end

      def word_found?(word)
        dictionary.include?(word)
      end
    end
  end
end
