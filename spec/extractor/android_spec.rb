require "spec_helper"

describe "Vocab::Extractor::Android" do

  before( :each ) do
    @locale = "#{vocab_root}/spec/data/android/locales/values/strings.xml"
  end

  describe 'extract_current' do

    it "extracts hash of current string translations" do
      actual = Vocab::Extractor::Android.extract_current( @locale )
      actual.should eql( { "app_name"   =>"Kid Mode",
                           "delete"     =>"Delete",
                           "cancel"     =>"Cancel",
                           "app_current"=>"current",
                           "pd_app_name"=>"Parent Dashboard",
                           "not_in_es"  =>"This key not in spanish",
                           "debug_key"  =>"Should be ignored" } )
    end

  end

  describe 'extract_previous' do

    before( :each ) do
      Dir.chdir( vocab_root )
    end

    before( :each ) do
      @sha = '2302e5acb50a9b56d113c46805de5ae0c12d28c0'
      Vocab.settings.stub!( :last_translation ).and_return( @sha )
    end

    it "extracts hash of previous string translations" do
      actual = Vocab::Extractor::Android.extract_previous( @locale )
      actual.should eql( { 'app_name'    => 'Kid Mode',
                           'pd_app_name' => 'Parent Dashboard',
                           'app_current' => 'current' } )
    end

  end

  describe 'write_full' do

    it 'writes the full translation to the correct xml file' do
      hash = { 'foo' => 'bar' }
      Vocab::Translator::Android.should_receive( :write ).
              with( hash, "#{vocab_root}/strings.full.xml" )
      Vocab::Extractor::Android.write_full( hash )
    end

  end

  describe 'write_diff' do

    it 'writes the diff translation to the correct xml file' do
      hash = { 'foo' => 'bar' }
      Vocab::Translator::Android.should_receive( :write ).
              with( hash, "#{vocab_root}/strings.diff.xml" )
      Vocab::Extractor::Android.write_diff( hash )
    end

  end

  describe 'write' do

    it 'writes the translation to a xml file' do
      translation = { 'app_name' => 'Kid Mode',
                      'pd_app_name' => 'Parent Dashboard',
                      'delete' => "La funci&#xF3;n Child Lock" }
      path = "#{vocab_root}/spec/tmp/strings.xml"
      Vocab::Translator::Android.write( translation, path )
      strings = File.open( path ) { |f| f.read }
      strings.should eql_file( "spec/data/android/write.xml" )
      File.delete( path )
    end

  end

  describe 'examples' do

    it 'returns file names for completed translations' do
      dir = "#{vocab_root}/spec/data/android/locales"
      actual = Vocab::Extractor::Android.examples( dir )
      actual.should =~ [ "tmp/translations/values-es" ]
    end

    it 'uses the conventional android locales directory by default' do
      Vocab::Translator::Android.should_receive( :locales ).with( "#{vocab_root}/res/values" ).and_return( [] )
      Vocab::Extractor::Android.examples
    end

  end

end