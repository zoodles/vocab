# Cleans full translation files ending in "full.yml" in the vocab root directory by:
#   - removing empty keys
#   - replacing HTML codes with the corresponding UTF-8 characters (e.g. &gt; --> > )
#   - replacing \x[XX]\x[XX] codes with characters
#   - removing keys that shouldn't be translated (specified in a blacklist)

module Vocab
  module Cleaner
    class Rails < Base
      FULL_SUFFIX = 'full.yml'
      CLEAN_SUFFIX = 'clean.yml'
      BLACKLIST = [
          'devise',
          'active_record',
          'activerecord',
          'number',
          'datetime'
        ]

      class << self

        def clean_file( file )
          # TODO: use psych
          original_engine = YAML::ENGINE.yamler
          YAML::ENGINE.yamler='syck'
          entity_matcher = /&.+?;/
          coder = HTMLEntities.new( :expanded )

          translation = File.read( file )
          locale_name = File.basename(file, '.yml')
          clean_name = "#{File.dirname( file )}/#{locale_name}.#{CLEAN_SUFFIX}"

          cleaned_text = translation.gsub( entity_matcher ) { |entity| entity == "&quot;" ? "\\\"" : coder.decode( entity ) }
          cleaned_file = File.open( clean_name, "wb:UTF-8" )

          cleaned_file.puts( cleaned_text.encode( 'UTF-8' ) )
          cleaned_file.close

          translation_hash = YAML.load( File.open( clean_name, 'rb:UTF-8' ))

          cleaned_file = File.open( clean_name, 'wb:UTF-8')
          keys =  deep_stringify_valid_keys( translation_hash )
          cleaned_file.puts( keys_to_yaml( keys ) )
          cleaned_file.close

        ensure
          YAML::ENGINE.yamler=original_engine
        end

        def files_to_clean ( dir = Vocab.root )
          return Dir.glob( "#{dir}/*.#{FULL_SUFFIX}" )
        end

        private
        def keys_to_yaml( keys )
            # Using ya2yaml, if available, for UTF8 support
            keys.respond_to?( :ya2yaml ) ? keys.ya2yaml( :escape_as_utf8 => true ) : keys.to_yaml
        end

        # Stringifying keys for prettier YAML
        def deep_stringify_valid_keys( hash )
          hash.inject({}) { |result, (key, value)|
            if valid_key?( key ) 
              value = deep_stringify_valid_keys(value) if value.is_a? Hash
              unless value.to_s.empty? or value == {}
                result[(key.to_s rescue key) || key] = value
              end
            end
            result

          }
        end

        def valid_key?( key )
          BLACKLIST.each do |prefix|
            if key.to_s.include?( prefix )
              return false
            end
          end
          return true
        end
      end
    end
  end
end