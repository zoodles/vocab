module Vocab
  module Merger
    class Rails

      attr_accessor :locales_dir, :updates_dir

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge
        update_files = Dir.glob( "#{updates_dir}/**/*.yml" )
        update_files.each do |path|
          filename = File.basename( path )
          merge_file( filename )
        end
      end

      def merge_file( filename )
        locales_path = "#{@locales_dir}/#{filename}"
        update_path = "#{@updates_dir}/#{filename}"
        return unless File.exists?( locales_path ) && File.exists?( update_path )

        locales_translator = Vocab::Translator.new
        locales_translator.load_file( locales_path )
        locales = locales_translator.flattened_translations

        updates_translator = Vocab::Translator.new
        updates_translator.load_file( update_path )
        updates = updates_translator.flattened_translations

        # apply updated keys to locales hash
        updates.each do |key, value|
          locales_translator.store( key, value ) if locales.has_key?( key )
        end

        File.open( locales_path, 'w+' ) { |f| f.write( locales_translator.translations.to_yaml ) }
      end

    end
  end
end