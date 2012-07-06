# Cleans full translation files ending in "full.yml" in the vocab root directory by:
#   - removing empty keys
#   - replacing HTML codes with the corresponding UTF-8 characters (e.g. &gt; --> > )
#   - replacing \x[XX]\x[XX] codes with characters
#   - removing keys that shouldn't be translated (specified in a blacklist)

module Vocab
  module Cleaner
    class Rails < Base
      FULL_SUFFIX = 'full.yml'
      DIFF_SUFFIX = 'diff.yml'
      CLEAN_SUFFIX = 'clean.yml'
      BLACKLIST = [
          'devise',
          'active_record',
          'activerecord',
          'number',
          'datetime'
        ]
      WINDOWS_TO_UTF8 = {
                "\\xC2\\x80" => "\xe2\x82\xac", # EURO SIGN
                "\\xC2\\x82" => "\xe2\x80\x9a", # SINGLE LOW-9 QUOTATION MARK
                "\\xC2\\x83" => "\xc6\x92",     # LATIN SMALL LETTER F WITH HOOK
                "\\xC2\\x84" => "\xe2\x80\x9e", # DOUBLE LOW-9 QUOTATION MARK
                "\\xC2\\x85" => "\xe2\x80\xa6", # HORIZONTAL ELLIPSIS
                "\\xC2\\x86" => "\xe2\x80\xa0", # DAGGER
                "\\xC2\\x87" => "\xe2\x80\xa1", # DOUBLE DAGGER
                "\\xC2\\x88" => "\xcb\x86",     # MODIFIER LETTER CIRCUMFLEX ACCENT
                "\\xC2\\x89" => "\xe2\x80\xb0", # PER MILLE SIGN
                "\\xC2\\x8A" => "\xc5\xa0",     # LATIN CAPITAL LETTER S WITH CARON
                "\\xC2\\x8B" => "\xe2\x80\xb9", # SINGLE LEFT-POINTING ANGLE QUOTATION
                "\\xC2\\x8C" => "\xc5\x92",     # LATIN CAPITAL LIGATURE OE
                "\\xC2\\x8E" => "\xc5\xbd",     # LATIN CAPITAL LETTER Z WITH CARON
                "\\xC2\\x91" => "\xe2\x80\x98", # LEFT SINGLE QUOTATION MARK
                "\\xC2\\x92" => "\xe2\x80\x99", # RIGHT SINGLE QUOTATION MARK
                "\\xC2\\x93" => "\xe2\x80\x9c", # LEFT DOUBLE QUOTATION MARK
                "\\xC2\\x94" => "\xe2\x80\x9d", # RIGHT DOUBLE QUOTATION MARK
                "\\xC2\\x95" => "\xe2\x80\xa2", # BULLET
                "\\xC2\\x96" => "\xe2\x80\x93", # EN DASH
                "\\xC2\\x97" => "\xe2\x80\x94", # EM DASH

                "\\xC2\\x98" => "\xcb\x9c",     # SMALL TILDE
                "\\xC2\\x99" => "\xe2\x84\xa2", # TRADE MARK SIGN
                "\\xC2\\x9A" => "\xc5\xa1",     # LATIN SMALL LETTER S WITH CARON
                "\\xC2\\x9B" => "\xe2\x80\xba", # SINGLE RIGHT-POINTING ANGLE QUOTATION
                "\\xC2\\x9C" => "\xc5\x93",     # LATIN SMALL LIGATURE OE
                "\\xC2\\x9E" => "\xc5\xbe",     # LATIN SMALL LETTER Z WITH CARON
                "\\xC2\\x9F" => "\xc5\xb8"      # LATIN CAPITAL LETTER Y WITH DIAERESIS
        }

      class << self

        def clean_file( file )
          @file = file
          @locale_name = File.basename( @file, '.yml' )
          @clean_dir = File.dirname( @file )
          @clean_name = "#{@clean_dir}/#{@locale_name}.#{CLEAN_SUFFIX}"

          replace_codes
          clean_yaml
        end

        def files_to_clean ( dir = Vocab.root )
          return ( Dir.glob( "#{dir}/*.#{FULL_SUFFIX}" ) + Dir.glob( "#{dir}/*.#{DIFF_SUFFIX}" ) )
        end

        private
        def replace_codes
          translation = File.read( @file )

          cleaned_text = replace_html_codes( translation )
          cleaned_text = replace_windows_codes( cleaned_text )

          cleaned_file = File.open( @clean_name, 'w' )
          cleaned_file.puts( cleaned_text )
          cleaned_file.close
        end

        def replace_html_codes( translation )
          entity_matcher = /&.+?;/
          coder = HTMLEntities.new( :expanded )
        
          cleaned_text = translation.gsub( entity_matcher ) do |entity| 
            entity == "&quot;" ? "\\\"" : coder.decode( entity )
          end

          return cleaned_text
        end

        def replace_windows_codes( translation )
          WINDOWS_TO_UTF8.each { |windows_code,utf8_code| translation.gsub!( windows_code, utf8_code ) }
          return translation
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