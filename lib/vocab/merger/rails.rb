module Vocab
  module Merger
    class Rails < Base

      attr_accessor :locales_dir, :updates_dir

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge
        locales_files = Dir.glob( "#{locales_dir}/**/*.yml" )
        locales_files.each do |path|
          merge_file( path )
        end
        finalize
      end

      def merge_file( locales_path )
        return unless translatable?( locales_path )
        create_if_missing( locales_path )

        # list of keys that need to be in the translated file
        keys = Vocab::Merger::Rails.keys_for_file( locales_path )

        # existing translations already in the file
        locales_translator = translator( locales_path )
        locales = locales_translator.flattened_translations

        # new translations from the translators
        update_path = "#{@updates_dir}/#{locales_translator.locale}.yml"
        unless File.exists?( update_path )
          Vocab.ui.say( "Missing update file: #{update_path} to translate #{locales_path}" )
          return
        end
        updates_translator = translator( update_path )
        updates = updates_translator.flattened_translations

        # apply updated keys to locales hash
        keys.each do |key|
          value = updates[ key ]
          value ||= locales[ key ]
          locales_translator.store( key, value )
        end

        locales_translator.write_file( locales_path )
      end

      def self.keys_for_file( path )
        en_path = Vocab::Merger::Rails.en_equivalent_path( path )
        translator = Vocab::Translator.new
        translator.load_file( en_path )
        return translator.flattened_translations.keys
      end

      def self.en_equivalent_path( path )
        return "#{File.dirname( path )}/en.yml"
      end

    protected

      def translatable?( path )
        return false unless File.exists?( Vocab::Merger::Rails.en_equivalent_path( path ) )
        return true
      end

      def translator( path )
        translator = Vocab::Translator.new
        translator.load_file( path ) if File.exists?( path )
        return translator
      end

      def create_if_missing( path )
        return if File.exists?( path )
        locale = File.basename( path, '.yml' )
        File.open( path, 'w+' ) { |file| file.write( { locale => {} }.to_yaml ) }
      end

    end
  end
end