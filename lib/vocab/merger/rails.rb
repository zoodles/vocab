module Vocab
  module Merger
    class Rails

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
      end

      def merge_file( filename )
        locales_path = filename

        unless File.exists?( locales_path )
          Vocab.ui.say( "Missing locale file: #{locales_path}" )
          return
        end

        locales_translator = Vocab::Translator.new
        locales_translator.load_file( locales_path )
        locales = locales_translator.flattened_translations

        update_path = "#{@updates_dir}/#{locales_translator.locale}.yml"
        unless File.exists?( update_path )
          Vocab.ui.say( "Missing update file: #{update_path} to translate #{locales_path}" )
          return
        end

        updates_translator = Vocab::Translator.new
        updates_translator.load_file( update_path )
        updates = updates_translator.flattened_translations

        # apply updated keys to locales hash
        updates.each do |key, value|
          locales_translator.store( key, value ) if locales.has_key?( key )
        end

        locales_translator.write_file( locales_path )
      end

    protected

      def translation_file( locale )
        return "#{@updates_dir}/#{locales_translator.locale}.yml"
      end

    end
  end
end