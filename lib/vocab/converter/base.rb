module Vocab
  module Converter
    class Base
     class << self
        def convert_xml_to_yml( path = nil)
          Vocab.ui.say( "No conversion available" )
          return nil
        end

        def convert_yml_to_xml( path = nil)
          Vocab.ui.say( "No conversion available" )
          return nil
        end
      end
    end
  end
end