module Vocab
  module Validator
    class Rails < Base

      def initialize( locales_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
      end

      def other_keys( path )
        return flattened_keys( path )
      end

      def string_keys( path )
        return flattened_keys( Vocab::Translator::Rails.en_equivalent_path( path ) )
      end

      def files_to_validate
        return Dir.glob( "#{@locales_dir}/**/*.yml" ).reject { |path| File.basename( path ) == 'en.yml' }
      end

      def pre_validate( path )
        bom_regex = "\xEF\xBB\xBF".force_encoding("UTF-8")
        File.open( path ) do |file|
          content = file.read.force_encoding( "UTF-8" )
          if content.match( bom_regex )
            Vocab.ui.warn( "Found a leading BOM character in #{path}" )
            return false
          end
          return true
        end
      end

    protected

      def flattened_keys( path )
        translator = Vocab::Translator::Rails.new
        translator.load_file( path )
        return translator.flattened_translations.keys.collect { |key| key.to_s }
      end

    end
  end
end