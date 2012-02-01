require 'nokogiri'

module Vocab
  module Extractor
    class Android < Base
      class << self

        def extract_current( path = nil )
          path ||= "#{Vocab.root}/tmp/last_translation/strings.xml"
          return hash_from_xml( path )
        end

        def extract_previous( path = nil )
          path ||= "#{Vocab.root}/tmp/last_translation/strings.xml"
          puts "path = #{path}"
          sha = Vocab.settings.last_translation
          xml = previous_file( path, sha )

          puts "Vocab.root = #{Vocab.root}"
          tmpfile = "#{Vocab.root}/tmp/last_translation/#{File.basename(path)}"
          File.open( tmpfile, 'w' ) { |f| f.write( xml ) }
          return hash_from_xml( tmpfile )
        end

        def write_diff( diff, path = nil )
          path ||= "#{Vocab.root}/strings.diff.xml"
          write( diff, path )
        end

        def write_full( diff, path = nil )
          path ||= "#{Vocab.root}/strings.full.xml"
          write( diff, path )
        end

        def hash_from_xml( path )
          doc = Nokogiri::XML( File.open( path ) ) { |config| config.noblanks }
          children = doc.search( '/resources' ).children
          hash = {}
          children.each { |child| hash[ child['name'] ] = child.text }
          return hash
        end

        def write( hash, path )
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.resources {
              hash.each do |key, value|
                xml.string( value, :name => key )
              end
            }
          end
          File.open( path, 'w' ) { |f| f.write( builder.to_xml ) }
        end

      end
    end
  end
end