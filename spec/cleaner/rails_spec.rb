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
      output.strip.should eql( expected.strip )
    end

    it 'replaces Windows-1252 codes with translatable UTF-8 codes' do
      file = "#{@update_dir}/en.full.yml"
      cleaned_filename= "#{@update_dir}/en.full.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      expected = File.read( "#{@update_dir}/en.expected.yml" )
      output = File.open( cleaned_filename, "r:UTF-8" ).read
      output.strip.should eql( expected.strip )
    end

    it 'replaces HTML entity codes with symbols' do
      file = "#{@update_dir}/fr.full.yml"
      cleaned_filename = "#{@update_dir}/fr.full.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      expected = File.read( "#{@update_dir}/fr.expected.yml" ) 
      output = File.open( cleaned_filename, "r:UTF-8" ).read
      output.strip.should eql( expected.strip )
    end

    it 'removes keys with empty values' do
      file = "#{@update_dir}/fr.full.yml"
      cleaned_filename = "#{@update_dir}/fr.full.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      output = File.open( cleaned_filename, "r:UTF-8" ).read
      output.should_not include( "error_facebook:", "collection_controller:", "error_collection" )
    end

    it 'names clean diff files correctly' do
      file = "#{@update_dir}/test.diff.yml"
      cleaned_filename = "#{@update_dir}/test.diff.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      File.should exist( cleaned_filename )
    end

    it 'removes blacklisted keys' do
      file = "#{@update_dir}/fr.full.yml"
      cleaned_filename = "#{@update_dir}/fr.full.clean.yml"
      Vocab::Cleaner::Rails.clean_file( file )
      output = File.open( cleaned_filename, "r:UTF-8" ).read
      output.should_not include( "active_record" )
    end
  end

  describe 'files_to_clean' do

    before( :each ) do
      @update_dir = "#{vocab_root}/spec/data/rails/full"
      @path = "#{vocab_root}/spec/data/rails/full"
    end

    it 'finds translation files to clean' do
      expected = [ "#{@update_dir}/es.full.yml",
                   "#{@update_dir}/cn.full.yml",
                   "#{@update_dir}/fr.full.yml",
                   "#{@update_dir}/en.full.yml",
                   "#{@update_dir}/test.diff.yml" ]
      Vocab::Cleaner::Rails.files_to_clean( @path ).should =~ ( expected )
    end
  end
  
end