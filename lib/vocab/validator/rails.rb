module Vocab
  module Validator
    class Rails < Base

      def initialize( locales_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
      end

      def other_keys( path )
        return flattened_keys( path )
      end

      def english_keys( path )
        return flattened_keys( Vocab::Translator::Rails.en_equivalent_path( path ) )
      end

      def files_to_validate
        return Dir.glob( "#{@locales_dir}/**/*.yml" ).reject { |path| File.basename( path ) == 'en.yml' }
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