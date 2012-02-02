module Vocab
  module Translator
    class Android

      def self.hash_from_xml( path )
        doc = Nokogiri::XML( File.open( path ) ) { |config| config.noblanks }
        children = doc.search( '/resources/string' )
        hash = {}
        children.each { |child| hash[ child['name'] ] = child.text }
        return hash
      end

      def self.write( hash, path )
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