require 'i18n'
require 'fileutils'

module Vocab
  module Extractor
    class Base
      class << self
        def extract( path = nil )
          current = extract_current
          previous = extract_previous
          diff = diff( previous, current )
          write_diff( diff, path )
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
      end
    end
  end
end