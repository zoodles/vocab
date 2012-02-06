module Vocab
  module Validator
    class Base

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
        other = other_keys( path )
        english = english_keys( path )

        result = {}
        result[ :missing ] = ( english - other ).sort
        result[ :extra ] = ( other - english ).sort
        return result
      end

    end
  end
end