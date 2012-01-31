module Vocab
  module Extractor
    class Base
      class << self
        def extract( diff_path = nil, full_path = nil )
          current = extract_current
          previous = extract_previous
          diff = diff( previous, current )
          write_diff( diff, diff_path )
          write_full( current, full_path )
        end

        # make a hash of all the translations that are new or changed in the current yml
        def diff( previous, current )
          diff = {}
          current.each do |key, value|
            previous_value = previous[ key ]
            if( previous_value.nil? || previous_value != value )
              diff[ key ] = value
            end
          end
          return diff
        end

        def extract_previous
          raise "not implemented"
        end

        def extract_current
          raise "not implemented"
        end

        def write_diff( diff, path )
          raise "not implemented"
        end

        def write_full( diff, path )
          raise "not implemented"
        end

        def previous_file( path, sha )
          path = path.gsub( "#{Vocab.root}/", '' )
          return `cd #{Vocab.root} && git show #{sha}:#{path}`
        end

      end
    end
  end
end