module Vocab
  module Validator
    class Android

      def initialize( locales_dir = nil )
        @locales_dir = locales_dir || 'res'
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

    end
  end
end