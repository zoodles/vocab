module Vocab
  module Translator
    class Android

      def self.hash_from_xml( path )
        xml = File.open( path ) { |f| f.read }
        doc = Nokogiri::HTML.fragment( xml ) { |config| config.noblanks }
        children = doc.search( 'resources/string' )
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

      def self.english_keys( locales_dir )
        path = "#{locales_dir}/values/strings.xml"
        translations = Vocab::Translator::Android.hash_from_xml( path )
        return translations.keys
      end

    end
  end
end