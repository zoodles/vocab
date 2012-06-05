module Vocab
  module Validator
    class Base

      # Returns false if validation fails
      def validate
        ok = true
        
        files = files_to_validate
        Vocab.ui.say( "#{files.size} file(s) to validate in #{@locales_dir}" )
        files.each do |path|
          ok &&= pre_validate( path )
          validation = validate_file( path )
          print( path, validation )
          ok &&= validation[ :missing ] && validation[ :missing ].empty?
        end
        
        return ok
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
        english = string_keys( path )

        result = {}
        result[ :missing ] = ( english - other ).sort
        result[ :extra ] = ( other - english ).sort
        return result
      end

      # Override in subclass
      def pre_validate( path )
        return true
      end

    end
  end
end