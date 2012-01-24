module Vocab
  module Merger
    class Rails

      attr_accessor :locales_dir, :updates_path

      def initialize( locales_dir = nil, updates_path = nil )
        @locales_dir = locales_dir || 'config/locales'
        @updates_path = updates_path || 'tmp/translations/en.yml'
      end

      def merge
        return unless File.exists?( @updates_path )
        locales_files = Dir.glob( "#{locales_dir}/**/*.yml" )
        locales_files.each do |path|
          merge_file( path )
        end
      end

      def merge_file( filename )
        locales_path = filename
        return unless File.exists?( locales_path )

        locales_translator = Vocab::Translator.new
        locales_translator.load_file( locales_path )
        locales = locales_translator.flattened_translations

        updates_translator = Vocab::Translator.new
        updates_translator.load_file( @updates_path )
        updates = updates_translator.flattened_translations

        # apply updated keys to locales hash
        updates.each do |key, value|
          locales_translator.store( key, value ) if locales.has_key?( key )
        end

        master = { :en => locales_translator.translations }
        File.open( locales_path, 'w+' ) { |f| f.write( master.to_yaml ) }
      end

    end
  end
end