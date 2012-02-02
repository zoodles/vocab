module Vocab
  module Merger
    class Android < Base

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'res'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge
        Vocab.ui.say( 'Implement me in lib/vocab/merger/android.rb' )
        # integrate the translations from tmp/translations into the relevant strings.xml files
        #  - add updates to existing translations
        #  - write whole files to new translations
      end

      def merge_file( path )
        keys = english_keys
        current = current_for_locale( path )
        updates = updates_for_locale( path )

        translation = {}
        keys.each do |key|
          translation[ key ] = updates[ key ] || current[ key ]
        end

        Vocab::Translator::Android.write( translation, path )
      end

      def english_keys
        path = "#{@locales_dir}/values/strings.xml"
        translations = Vocab::Translator::Android.hash_from_xml( path )
        return translations.keys
      end

      def current_for_locale( path )
        Vocab::Translator::Android.hash_from_xml( path )
      end

      def updates_for_locale( path )
        name = path.gsub( "#{@locales_dir}/", '' )
        update = "#{updates_dir}/#{name}"
        Vocab::Translator::Android.hash_from_xml( update )
      end

    end
  end
end