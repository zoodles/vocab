module Vocab
  module Merger
    class Android < Base

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'res'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge_file( path )
        strings = strings( path )
        plurals = plurals( path )
        Vocab::Translator::Android.write( strings, plurals, path )
      end

      def strings( path )
        keys = english_keys
        current = current_for_locale( path )
        updates = updates_for_locale( path )
        return translation_hash( keys, current, updates, path )
      end

      def plurals( path )
        keys = plural_keys
        current = current_plurals_for_locale( path )
        updates = update_plurals_for_locale( path )
        return translation_hash( keys, current, updates, path )
      end

      def translation_hash( keys, current, updates, path )
        translation = {}
        keys.each do |key|
          next if Vocab::Translator::Base.ignore_key?( key )

          value = updates[ key ] || current[ key ]
          if value
            translation[ key ] = value
          else
            Vocab.ui.warn( "No translation found for key #{key} while merging #{path}" )
          end
        end

        return translation
      end

      def english_keys
        return Vocab::Translator::Android.english_keys( @locales_dir )
      end

      def plural_keys
        return Vocab::Translator::Android.plural_keys( @locales_dir )
      end

      def current_for_locale( path )
        return Vocab::Translator::Android.hash_from_xml( path )
      end

      def updates_for_locale( path )
        update = update_file_path( path )
        return Vocab::Translator::Android.hash_from_xml( update )
      end

      def current_plurals_for_locale( path )
        return Vocab::Translator::Android.plurals_from_xml( path )
      end

      def update_plurals_for_locale( path )
        update = update_file_path( path )
        return Vocab::Translator::Android.plurals_from_xml( update )
      end

      def translation_locales
        return Vocab::Translator::Android.locales( @updates_dir, false )
      end

      def files_to_merge
        return translation_locales.collect do |locale|
          "#{@locales_dir}/values-#{locale}/strings.xml"
        end
      end

      def update_file_path( path )
        name = path.gsub( "#{@locales_dir}/", '' )
        dirname = File.dirname( name )
        entries = Dir.glob( "#{updates_dir}/#{dirname}/*.xml" )
        Vocab.ui.warn( "Multiple update files for #{path}: #{entries.join( ',' )}" ) if entries.size > 1
        return entries.first
      end

    end
  end
end