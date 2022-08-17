# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

require_relative 'LittleWeasel/block_results'
require_relative 'LittleWeasel/configure'
require_relative 'LittleWeasel/dictionary'
require_relative 'LittleWeasel/dictionary_key'
require_relative 'LittleWeasel/dictionary_manager'
require_relative 'LittleWeasel/errors/dictionary_file_already_loaded_error'
require_relative 'LittleWeasel/errors/dictionary_file_empty_error'
require_relative 'LittleWeasel/errors/dictionary_file_not_found_error'
require_relative 'LittleWeasel/errors/dictionary_file_too_large_error'
require_relative 'LittleWeasel/errors/language_required_error'
require_relative 'LittleWeasel/errors/must_override_error'
require_relative 'LittleWeasel/filters/en_us/currency_filter'
require_relative 'LittleWeasel/filters/en_us/numeric_filter'
require_relative 'LittleWeasel/filters/en_us/single_character_word_filter'
require_relative 'LittleWeasel/filters/word_filter'
require_relative 'LittleWeasel/filters/word_filter_managable'
require_relative 'LittleWeasel/filters/word_filter_validatable'
require_relative 'LittleWeasel/filters/word_filterable'
require_relative 'LittleWeasel/filters/word_filters_validatable'
require_relative 'LittleWeasel/metadata/dictionary_metadata'
require_relative 'LittleWeasel/metadata/invalid_words_metadata'
require_relative 'LittleWeasel/metadata/invalid_words_service_results'
require_relative 'LittleWeasel/metadata/metadata_observable_validatable'
require_relative 'LittleWeasel/metadata/metadata_observerable'
require_relative 'LittleWeasel/metadata/metadatable'
require_relative 'LittleWeasel/modules/class_name_to_symbol'
require_relative 'LittleWeasel/modules/configurable'
require_relative 'LittleWeasel/modules/deep_dup'
require_relative 'LittleWeasel/modules/dictionary_cache_keys'
require_relative 'LittleWeasel/modules/dictionary_cache_servicable'
require_relative 'LittleWeasel/modules/dictionary_cache_validatable'
require_relative 'LittleWeasel/modules/dictionary_creator_servicable'
require_relative 'LittleWeasel/modules/dictionary_file_loader'
require_relative 'LittleWeasel/modules/dictionary_key_validatable'
require_relative 'LittleWeasel/modules/dictionary_keyable'
require_relative 'LittleWeasel/modules/dictionary_metadata_servicable'
require_relative 'LittleWeasel/modules/dictionary_metadata_validatable'
require_relative 'LittleWeasel/modules/dictionary_source_validatable'
require_relative 'LittleWeasel/modules/dictionary_sourceable'
require_relative 'LittleWeasel/modules/dictionary_validatable'
require_relative 'LittleWeasel/modules/language'
require_relative 'LittleWeasel/modules/language_validatable'
require_relative 'LittleWeasel/modules/locale'
require_relative 'LittleWeasel/modules/order_validatable'
require_relative 'LittleWeasel/modules/orderable'
require_relative 'LittleWeasel/modules/region'
require_relative 'LittleWeasel/modules/region_validatable'
require_relative 'LittleWeasel/modules/tag_validatable'
require_relative 'LittleWeasel/modules/taggable'
require_relative 'LittleWeasel/modules/word_results_validatable'
require_relative 'LittleWeasel/preprocessors/en_us/capitalize_preprocessor'
require_relative 'LittleWeasel/preprocessors/preprocessed_word'
require_relative 'LittleWeasel/preprocessors/preprocessed_word_validatable'
require_relative 'LittleWeasel/preprocessors/preprocessed_words'
require_relative 'LittleWeasel/preprocessors/preprocessed_words_validatable'
require_relative 'LittleWeasel/preprocessors/word_preprocessable'
require_relative 'LittleWeasel/preprocessors/word_preprocessor'
require_relative 'LittleWeasel/preprocessors/word_preprocessor_managable'
require_relative 'LittleWeasel/preprocessors/word_preprocessor_validatable'
require_relative 'LittleWeasel/preprocessors/word_preprocessors_validatable'
require_relative 'LittleWeasel/services/dictionary_cache_service'
require_relative 'LittleWeasel/services/dictionary_creator_service'
require_relative 'LittleWeasel/services/dictionary_file_loader_service'
require_relative 'LittleWeasel/services/dictionary_killer_service'
require_relative 'LittleWeasel/services/dictionary_metadata_service'
require_relative 'LittleWeasel/services/invalid_words_service'
require_relative 'LittleWeasel/version'
require_relative 'LittleWeasel/word_results'
