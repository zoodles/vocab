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

    end
  end
end