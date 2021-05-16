# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary, class: LittleWeasel::Dictionary do
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
      new dictionary_words
    end
  end
end
