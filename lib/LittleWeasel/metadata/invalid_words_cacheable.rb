# frozen_string_literal: true

module LittleWeasel
  module Metadata
    module InvalidWordsCacheable
      def word_valid?(word)
        _cached, found = cache_word_if! word
        found
      end

      private

      def cache_word_if!(word)
        return [true, true] if word_found_and_valid? word

        cache = cache_word? word
        if cache
          # TODO: Should this invalid word be placed under
          # metadata separately, or added to the dictionary?
          dictionary[word] = false
          metadata.current_invalid_word_bytesize += word.bytesize
        end

        [cache, false]
      end

      # This method returns true if the current start of the metadata
      # says we should cache the invalid word; this is based on the
      # configuration (initially) and the calculated results of the
      # total bytes of invalid words thereafter. If the threshold is
      # exceeded, no more words are cached (to avoid exploits). If the
      # threashold is NOT exceeded, the invlaid word is cached.
      # Do not call this method if the word is valid (e.g. found in
      # the dictionary).
      def cache_word?(word)
        return false unless metadata.cache_invalid_words?

        metadata.value > (word.bytesize + metadata.current_invalid_word_bytesize)
      end

      def word_found_and_valid?(word)
        dictionary.include?(word) && dictionary[word]
      end
    end
  end
end
