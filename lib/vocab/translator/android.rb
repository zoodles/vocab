module Vocab
  module Translator
    class Android < Base

      def self.hash_from_xml( path )
        doc = doc_from_xml( path )
        children = doc.search( 'resources/string' )
        hash = {}
        children.each { |child| hash[ child['name'] ] = child.text }
        return hash
      end

      # Extracts plural definitions from xml to a hash
      #
      # For example:
      #
      #     <plurals name="user_count">
      #         <item quantity="one">1 user</item>
      #         <item quantity="many">%d users</item>
      #     </plurals>
      #
      # Is returned as:
      #
      #     { "user_count" => { "one"  => "1 user",
      #                         "many" => "%d users" } }
      def self.plurals_from_xml( path )
        doc = doc_from_xml( path )

        plurals = {}
        doc.search( 'resources/plurals' ).each do |plural|
          items = {}
          plural.search( 'item' ).each do |item|
            items[ item['quantity' ] ] = item.text
          end

          plurals[ plural['name'] ] = items
        end
        return plurals
      end

      def self.write( strings, plurals, path )
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.resources do
            strings.sort.each do |key, value|
              xml.string( value, :name => key )
            end

            plurals.keys.sort.each do |key|
              xml.plurals( :name => key ) do
                plurals[ key ].each do |quantity, value|
                  xml.item( value, :quantity => quantity )
                end
              end
            end
          end
        end
        File.open( path, 'w' ) { |f| f.write( builder.to_xml( :encoding => 'UTF-8' ) ) }
      end

      def self.english_keys( locales_dir )
        path = "#{locales_dir}/values/strings.xml"
        translations = Vocab::Translator::Android.hash_from_xml( path )
        keys = translations.keys.map { |key| Vocab::Translator::Base.ignore_key?( key ) ? nil : key }.compact
        return keys
      end

      def self.locales( dir, strict = true )
        xml_pattern = strict ? 'strings.xml' : '*'

        locales = []
        Dir.glob( "#{dir}/values-*/#{xml_pattern}" ).each do |path|
          locales << $1 if path =~ /values-(.*)\//
        end
        return locales
      end

      #########################################################################
      # Helper methods
      #########################################################################

      def self.doc_from_xml( path )
        xml = File.open( path ) { |f| f.read }
        doc = Nokogiri::HTML.fragment( xml ) { |config| config.noblanks }
        return doc
      end

    end
  end
end