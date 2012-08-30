require "spec_helper"

describe "Vocab::Converter::Base" do

  describe 'convert_xml_to_yml' do

    it 'Displays a message if no xml to yml conversion is available' do
      Vocab.ui.should_receive( :say ).with( "No conversion available" )
      Vocab::Converter::Base.convert_xml_to_yml()
    end

  end

  describe 'convert_yml_to_xml' do

    it 'Displays a message if no yml to xml conversion is available' do
      Vocab.ui.should_receive( :say ).with( "No conversion available" )
      Vocab::Converter::Base.convert_yml_to_xml()
    end

  end

end