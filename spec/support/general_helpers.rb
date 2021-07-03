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

    module DictionaryResultsHelpers
      module_function

      def print_word_results(word, word_results, comments = nil)
        puts "# Comments: #{comments}" unless comments.nil?
        puts "# Results of calling #word_results for '#{word}'..."
        print_results(word: word, results: word_results, indent: 1)
      end

      def print_block_results(word_block, block_results, comments = nil)
        puts "# Comments: #{comments}" unless comments.nil?
        puts '# Results of calling #word_block with:'
        puts "#   \"#{word_block}\"..."
        puts
        puts 'block_results #=>'
        puts "  #preprocessed_words_or_original_words #=> #{block_results.preprocessed_words_or_original_words}"

        puts 'word_results #=>'
        block_results.word_results.each do |word_results|
          print_results(word: word_results.original_word, results: word_results, indent: 1)
        end
      end

      def print_results(word:, results:, indent: 0)
        indent = '   ' * indent
        puts "#{indent}word_results #=>"
        puts "#{indent * 2}original_word #=> \"#{results.original_word}\""
        puts "#{indent * 2}preprocessed_word #=> #{string_or_nil results.preprocessed_word}"
        puts "#{indent * 2}success? #=> #{results.success?}"
        puts "#{indent * 2}word_valid? #=> #{results.word_valid?}"
        puts "#{indent * 2}word_cached? #=> #{results.word_cached?}"
        puts "#{indent * 2}preprocessed_word? #=> #{results.preprocessed_word?}"
        puts "#{indent * 2}preprocessed_word_or_original_word #=> #{string_or_nil results.preprocessed_word_or_original_word}"
        puts "#{indent * 2}filter_match? #=> #{results.filter_match?}"
        puts "#{indent * 2}filters_matched: #=> #{results.filters_matched}"
        puts "#{indent * 2}preprocessed_words #=>"
        results.preprocessed_words&.preprocessed_words.each_with_index do |preprocessed_word, index|
          puts "#{indent * 3}preprocessed_words[#{index}] #=>"
          puts "#{indent * 4}preprocessed_word #=>"
          puts "#{indent * 5}preprocessor: :#{preprocessed_word.preprocessor}"
          puts "#{indent * 5}preprocessor_order: #{preprocessed_word.preprocessor_order}"
        end
        puts
      end

      def string_or_nil(value)
        return 'nil' if value.nil?
        "\"#{value}\""
      end
    end
  end
end
