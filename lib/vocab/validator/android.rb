module Vocab
  module Validator
    class Android

      def initialize( locales_dir = nil )
        @locales_dir = locales_dir || 'res'
      end

      def validate
        files = files_to_validate
        Vocab.ui.say( "#{files.size} file(s) to validate in #{@locales_dir}" )
        files.each do |path|
          validation = validate_file( path )
          print( path, validation )
        end
      end

      def print( path, validation )
        Vocab.ui.say( "Validating: #{path}" )

        unless validation[ :missing ].empty?
          Vocab.ui.say( "  Missing keys:" )
          validation[ :missing ].each { |missing| Vocab.ui.say( "    - #{missing}" ) }
        end

        unless validation[ :extra ].empty?
          Vocab.ui.say( "  Extra keys:" )
          validation[ :extra ].each { |extra| Vocab.ui.say( "    + #{extra}" ) }
        end
      end

      def validate_file( path )
        other = Vocab::Translator::Android.hash_from_xml( path ).keys

        result = {}
        result[ :missing ] = ( english_keys - other ).sort
        result[ :extra ] = ( other - english_keys ).sort
        return result
      end

      def english_keys
        return Vocab::Translator::Android.english_keys( @locales_dir )
      end

      def files_to_validate
        return Dir.glob( "#{@locales_dir}/values-*/strings.xml" )
      end

    end
  end
end