module Vocab
  module Merger
    class Android < Base
      FORMAT_PATTERN = /%(.+?)\b/ 
      ARG_PATTERN = /\$(.+?)\b/

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'res'
        @updates_dir = updates_dir || 'tmp/translations'
        @english_path = "#{@locales_dir}/values/strings.xml"
        if File.exists?( @english_path )
          @english_strings = english_strings
          @english_plurals = english_plurals
        end
      end

      def merge_file( path )
        strings = strings( path )
        plurals = plurals( path )
        Vocab::Translator::Android.write( strings, plurals, path )
      end

      def strings( path )
        keys = string_keys
        current = current_strings_for_locale( path )
        updates = update_strings_for_locale( path )
        return translation_hash( keys, current, updates, path, :string_format_changed? )
      end

      def plurals( path )
        keys = plural_keys
        current = current_plurals_for_locale( path )
        updates = update_plurals_for_locale( path )
        return translation_hash( keys, current, updates, path, :plural_format_changed? )
      end

      def translation_hash( keys, current, updates, path, format_checker = :string_format_changed? )
        translation = {}
        keys.each do |key|
          next if Vocab::Translator::Base.ignore_key?( key )

          value = updates[ key ] || current[ key ]
          if value
            translation[ key ] = value
            check_matching_format_strings( key, value, path, format_checker )
          else
            Vocab.ui.warn( "No translation found for key #{key} while merging #{path}" )
          end
        end

        return translation
      end

      def english_strings
        return Vocab::Translator::Android.hash_from_xml( @english_path )
      end

      def english_plurals
        return Vocab::Translator::Android.plurals_from_xml( @english_path )
      end
      
      def check_matching_format_strings( key, new_value, path, format_checker )
        send( format_checker, key, new_value, path) 
      end

      def plural_format_changed?( key, new_value, path )
        new_value.each do |inner_key,inner_value|
          if ( @english_plurals[ key ][ inner_key ].to_s.scan( FORMAT_PATTERN ) != inner_value.to_s.scan( FORMAT_PATTERN ) ) ||
           ( @english_plurals[ key ][ inner_key ].to_s.scan( ARG_PATTERN ) != inner_value.to_s.scan( ARG_PATTERN ) )
            Vocab.ui.warn( "Format string mismatch for key #{key}, quantity #{inner_key} while merging #{path}. \n English: #{@english_plurals[ key ][ inner_key ]} \n Translation: #{new_value[ inner_key ]}" )
          end
        end
      end

      def string_format_changed?( key, new_value, path )
        if ( @english_strings[ key ].to_s.scan( FORMAT_PATTERN ) != new_value.to_s.scan( FORMAT_PATTERN ) ) ||
           ( @english_strings[ key ].to_s.scan( ARG_PATTERN ) != new_value.to_s.scan( ARG_PATTERN ) )
          Vocab.ui.warn( "Format string mismatch for key #{key} while merging #{path}. \n English: #{@english_strings[ key ]} \n Translation: #{new_value}" )
        end
      end

      def string_keys
        return Vocab::Translator::Android.string_keys( @locales_dir )
      end

      def plural_keys
        return Vocab::Translator::Android.plural_keys( @locales_dir )
      end

      def current_strings_for_locale( path )
        return Vocab::Translator::Android.hash_from_xml( path )
      end

      def update_strings_for_locale( path )
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