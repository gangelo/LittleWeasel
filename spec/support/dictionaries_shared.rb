RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  # See https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-context
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'dictionaries_shared', shared_context: :metadata do
  let(:file_path) { File.join(File.dirname(__FILE__), 'files') }
  let(:dictionaries_hash) { {} }
  let(:all_dictionaries_hash) do
    {
      "en--" => "#{file_path}/en.txt",
      "en-US-" => "#{file_path}/en-US.txt",
      "en-GB-" => "#{file_path}/en-GB.txt",
      "es--" => "#{file_path}/es.txt",
      "es-ES-" => "#{file_path}/es-ES.txt",
    }
  end
end

RSpec.configure do |config|
  config.include_context 'dictionaries_shared', include_shared: true
end
