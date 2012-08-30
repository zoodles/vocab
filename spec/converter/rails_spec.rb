require "spec_helper"


describe "Vocab::Converter::Rails" do
  
  before( :each ) do
    @test_dir = "#{vocab_root}/spec/data/rails/xml"
  end
  
  describe 'convert_xml_to_yml' do
    it 'converts and xml file to a yml file' do
      xml_file = "#{@test_dir}/in_file.xml"
      yml_file = "#{@test_dir}/in_file.yml"
      Vocab::Converter::Rails.convert_xml_to_yml( xml_file )
      expected = File.read( "#{@test_dir}/out_file_expected.yml" )
      output = File.open( yml_file, "r:UTF-8" ).read
      output.strip.should eql( expected.strip )
    end
  end

  describe 'convert_yml_to_xml' do
    it 'converts an yml file to xml' do
      yml_file = "#{@test_dir}/test_file.yml"
      xml_file = "#{@test_dir}/test_file.xml"
      Vocab::Converter::Rails.convert_yml_to_xml( yml_file )
      expected = File.read( "#{@test_dir}/out_file_expected.xml" )
      output = File.open( xml_file, "r:UTF-8" ).read
      output.strip.should eql( expected.strip )
    end

  end
end