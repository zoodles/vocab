module Vocab
  module Validator
    class Android < Base

      def initialize( locales_dir = nil )
        @locales_dir = locales_dir || 'res'
      end

      def other_keys( path )
        return Vocab::Translator::Android.hash_from_xml( path ).keys
      end

      def string_keys( path = nil )
        return Vocab::Translator::Android.string_keys( @locales_dir )
      end

      def files_to_validate
        return Dir.glob( "#{@locales_dir}/values-*/strings.xml" )
      end

      # Override this method to do custom validation on the android xml string file
      def pre_validate( path )
        return true
      end

    end
  end
end