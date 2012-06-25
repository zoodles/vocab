module Vocab
  module Cleaner
    class Rails < Base
      FULL_SUFFIX = 'full.yml'
      CLEAN_SUFFIX = 'clean.yml'

      class << self
        def clean_file( file )
          entity_matcher = /&.+?;/
          coder = HTMLEntities.new( :expanded )
          translation = File.read( file )
          locale_name = File.basename(file, '.yml')

          # TODO find a better way to escape the quotes so it doesn't have to be a special case
          #cleaned = translation.gsub( /&quot;/ ) { |entity| "\\\"" }
          cleaned = translation.gsub( entity_matcher ) { |entity| entity == "&quot;" ? "\\\"" : coder.decode( entity ) }
          cleaned_file = File.open( "#{locale_name}.#{CLEAN_SUFFIX}", "w" ) 
          cleaned_file.puts( cleaned.encode( 'UTF-8' ) )
          
          tr = YAML.load_file("#{locale_name}.#{CLEAN_SUFFIX}")

          keys =  deep_stringify_keys( tr )
          File.open( "#{locale_name}.#{CLEAN_SUFFIX}", 'w' ) {|f| f.puts( keys_to_yaml(keys) ) }
        end

        def files_to_clean
          return Dir.glob( "*.#{FULL_SUFFIX}" )
        end

        private
        def keys_to_yaml(keys)
            # Using ya2yaml, if available, for UTF8 support
            keys.respond_to?( :ya2yaml ) ? keys.ya2yaml( :escape_as_utf8 => true ) : keys.to_yaml
        end

        # Stringifying keys for prettier YAML
        def deep_stringify_keys(hash)
          hash.inject({}) { |result, (key, value)|
            value = deep_stringify_keys(value) if value.is_a? Hash
            result[(key.to_s rescue key) || key] = value
            result
          }
        end
      end
    end
  end
end