module Vocab
  module Converter
    class Rails < Base
      SEPARATOR_ESCAPE_CHAR = "\001"

      class << self 
        def convert_xml_to_yml( file = nil )
          xml_root = 'hash'
          keys = xml_to_yml_keys( Hash.from_xml( File.read( file ) )[ xml_root ] )
          unwound_keys = unwind_keys( keys )
          out_dir = File.dirname( file )
          out_file = "#{out_dir}/#{File.basename( file, '.xml' ) + '.yml'}"
          File.open( out_file, 'w' ) {|f| f.puts( ( keys_to_yaml( unwound_keys ) ) ) }
        end

        def xml_to_yml_keys( hash )
          hash.inject( {} ) { |result, ( key, value )|
            value = xml_to_yml_keys( value ) if value.is_a? Hash
            yml_key = key.gsub( "-", "_" )
            result[ yml_key ] = value
            result
          }
        end

        def unwind_keys( hash, separator = "." )
          result = {}
          hash.each do |key, value|
            keys = key.to_s.split( separator )
            curr = result
            curr = curr[ keys.shift ] ||= {} while keys.size > 1
                curr[ keys.shift ] = value
          end

          return result
        end

        def wind_keys( hash, separator = nil, subtree = false, prev_key = nil, result = {}, orig_hash = hash )
          separator ||= I18n.default_separator

          hash.each_pair do |key, value|
            key = escape_default_separator( key, separator )
            curr_key = [ prev_key, key ].compact.join( separator ).to_sym

            if value.is_a?( Hash )
              result[ curr_key ] = value if subtree
              wind_keys( value, separator, subtree, curr_key, result, orig_hash )
            else
              result[ unescape_default_separator( curr_key ) ] = value
            end
          end

          return result
        end

        def keys_to_yaml( keys )
          # Using ya2yaml, if available, for UTF8 support
          keys.respond_to?( :ya2yaml ) ? keys.ya2yaml( :escape_as_utf8 => true ) : keys.to_yaml
        end

        def keys_to_xml( keys )
          raise "to_xml is broken" unless keys.respond_to?( :to_xml )
          keys.to_xml
        end
      
        def convert_yml_to_xml( file = nil )
          xml_root = 'hash'
          yml = YAML.load_file( file )
          wound_keys = wind_keys( yml )

          out_dir = File.dirname( file )
          out_file = "#{out_dir}/#{File.basename( file, '.yml' ) + '.xml'}"
          File.open( out_file, 'w' ) { |f| f.puts( ( keys_to_xml( wound_keys ) ) ) }
        end

        def unescape_default_separator( key, separator = nil ) 
          key.to_s.tr( SEPARATOR_ESCAPE_CHAR, separator || I18n.default_separator ).to_sym
        end

        def escape_default_separator( key, separator = nil )
          key.to_s.tr( separator || I18n.default_separator, SEPARATOR_ESCAPE_CHAR )
        end

      end
    end
  end
end
