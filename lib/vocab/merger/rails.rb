module Vocab
  module Merger
    class Rails

      attr_accessor :locales_dir, :updates_dir

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge
        update_files = Dir.glob( "#{updates_path}/**/*.yml" )
        update_files.each do |path|
          filename = File.basename( path )
          merge_file( filename )
        end
      end

      def merge_file( filename )
        old_path = "#{@locales_dir}/#{filename}"
        update_path = "#{@updates_dir}/#{filename}"
        return unless File.exists?( old_path ) && File.exists?( update_path )

        old_translator = Vocab::Translator.new
        old_translator.load_file( old_path )
        old = old_translator.flattened_translations

        updates_translator = Vocab::Translator.new
        updates_translator.load_file( update_path )
        updates = updates_translator.flattened_translations

        new = Vocab::Translator.new

        # updates
        old.each do |key, value|
          new.store( key, updates[ key ] || value )
        end

        # new keys
        updates.each do |key, value|
          new.store( key, value ) if old[ key ].nil?
        end

        File.open( old_path, 'w+' ) { |f| f.write( new.translations.to_yaml ) }
      end

    end
  end
end