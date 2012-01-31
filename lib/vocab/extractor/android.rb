require 'nokogiri'

module Vocab
  module Extractor
    class Android < Base
      class << self

        def extract_current( path = nil )
          path ||= "#{Vocab.root}/spec/data/android/locales/strings.xml"
          doc = Nokogiri::XML( File.open( path ) ) { |config| config.noblanks }
          children = doc.search( '/resources' ).children
          current = {}
          children.each { |child| current[ child['name'] ] = child.text }
          return current
        end

        def extract_previous
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # return a flat hash representing the key/vals from the strings.xml from the previous SHA version
        end

        def write_diff( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing the strings that need to be updated
        end

        def write_full( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing all the strings for a new translation
        end

      end
    end
  end
end