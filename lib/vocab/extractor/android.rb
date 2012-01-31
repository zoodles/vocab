require 'nokogiri'

module Vocab
  module Extractor
    class Android < Base
      class << self

        def extract_current( path = nil )
          path ||= "#{Vocab.root}/spec/data/android/locales/strings.xml"
          return hash_from_xml( path )
        end

        def extract_previous( path = nil )
          path ||= "#{Vocab.root}/spec/data/android/locales/strings.xml"
          puts "path = #{path}"
          sha = Vocab.settings.last_translation
          xml = previous_file( path, sha )

          puts "Vocab.root = #{Vocab.root}"
          tmpfile = "#{Vocab.root}/tmp/last_translation/#{File.basename(path)}"
          File.open( tmpfile, 'w' ) { |f| f.write( xml ) }
          return hash_from_xml( tmpfile )
        end

        def write_diff( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing the strings that need to be updated
        end

        def write_full( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing all the strings for a new translation
        end

        def hash_from_xml( path )
          doc = Nokogiri::XML( File.open( path ) ) { |config| config.noblanks }
          children = doc.search( '/resources' ).children
          hash = {}
          children.each { |child| hash[ child['name'] ] = child.text }
          return hash
        end

      end
    end
  end
end