require "spec_helper"

describe "Vocab::Cleaner::Rails" do

  describe 'clean_file' do

    before( :each ) do
      @update_dir = "#{vocab_root}/spec/data/rails/full"
    end

    it 'replaces hex codes with symbols' do
     file = "#{@update_dir}/es.full.yml"
     cleaned_filename= "#{@update_dir}/es.full.clean.yml"
     Vocab::Cleaner::Rails.clean_file( file )
     expected = File.read( "#{@update_dir}/es.expected.yml" ) 
     output = File.open( cleaned_filename, "r:UTF-8" ).read
     output.should eql( expected )
     File.delete( cleaned_filename )

    end

    it 'replaces HTML entity codes with symbols' do
      file = "#{@update_dir}/fr.full.yml"
      cleaned_filename = "#{@update_dir}/fr.full.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      expected = File.read( "#{@update_dir}/fr.expected.yml" ) 
      output = File.open( cleaned_filename, "r:UTF-8" ).read
      output.should eql( expected )
      File.delete( cleaned_filename )

    end
  end

  describe 'files_to_clean' do

    before( :each ) do
      @update_dir = "#{vocab_root}/spec/data/rails/full"
      @path = "#{vocab_root}/spec/data/rails/full"
    end

    it 'finds translation files to clean' do
      expected = [ "#{@update_dir}/es.full.yml", "#{@update_dir}/cn.full.yml", "#{@update_dir}/fr.full.yml" ]
      Vocab::Cleaner::Rails.files_to_clean( @path ).sort.should eql( expected.sort )
    end
  end
  
end