# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary, class: LittleWeasel::Dictionary do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }
    dictionary_metadata { {} }
    word_filters {}
    dictionary_words do
      %w(apple
        better
        cat
        dog
        everyone
        fat
        game
        help
        italic
        jasmine
        kelp
        love
        man
        nope
        octopus
        popeye
        queue
        ruby
        stop
        top
        ultimate
        very
        was
        xylophone
        yes
        zebra)
    end

    skip_create
    initialize_with do
      new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, dictionary_words: dictionary_words, word_filters: word_filters
    end
  end
end
