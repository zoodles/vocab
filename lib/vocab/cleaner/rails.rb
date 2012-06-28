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
          @file = file
          @locale_name = File.basename( @file, '.yml' )
          @clean_dir = File.dirname( @file )
          @clean_name = "#{@clean_dir}/#{@locale_name}.#{CLEAN_SUFFIX}"

          replace_html_codes
          clean_yaml
        end

        def files_to_clean ( dir = Vocab.root )
          return Dir.glob( "#{dir}/*.#{FULL_SUFFIX}" )
        end

        private
        def replace_html_codes
          entity_matcher = /&.+?;/
          coder = HTMLEntities.new( :expanded )

          translation = File.read( @file )
        
          cleaned_text = translation.gsub( entity_matcher ) do |entity| 
            entity == "&quot;" ? "\\\"" : coder.decode( entity )
          end

          cleaned_file = File.open( @clean_name, 'w' )
          cleaned_file.puts( cleaned_text )
          cleaned_file.close
        end

        def clean_yaml
          # TODO: use psych
          original_engine = YAML::ENGINE.yamler
          YAML::ENGINE.yamler='syck'
          translation_hash = YAML.load( File.open( @clean_name, 'r' ))

          cleaned_file = File.open( @clean_name, 'w' )
          keys =  clean_keys( translation_hash )
          cleaned_file.puts( replace_hex_codes( keys ) )
          cleaned_file.close

          ensure
            YAML::ENGINE.yamler=original_engine

        end

        def replace_hex_codes( keys )
            # Using ya2yaml, if available, for UTF8 support
            keys.respond_to?( :ya2yaml ) ? keys.ya2yaml( :escape_as_utf8 => true ) : keys.to_yaml
        end

        def clean_keys( hash )
          hash.inject({}) { |result, (key, value)|
            if valid_key?( key ) 
              value = clean_keys(value) if value.is_a? Hash
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