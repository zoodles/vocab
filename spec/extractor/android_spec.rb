require "spec_helper"

describe "Vocab::Extractor::Android" do

  before( :each ) do
    @locale = "#{vocab_root}/spec/data/android/locales/values/strings.xml"
  end

  describe 'current_strings' do

    it "extracts hash of current string translations" do
      actual = Vocab::Extractor::Android.current_strings( @locale )
      actual.should include( { "app_name"   =>"Kid Mode",
                           "delete"     =>"Delete %1$d",
                           "cancel"     =>"Cancel",
                           "app_current"=>"current",
                           "pd_app_name"=>"Parent Dashboard",
                           "not_in_es"  =>"This key not in spanish",
                           "debug_key"  =>"Should be ignored" } )
    end

  end

  describe 'previous_strings' do

    before( :each ) do
      Dir.chdir( vocab_root )
    end

    before( :each ) do
      @sha = '2302e5acb50a9b56d113c46805de5ae0c12d28c0'
      Vocab.settings.stub!( :last_translation ).and_return( @sha )
    end

    it "extracts hash of previous string translations" do
      actual = Vocab::Extractor::Android.previous_strings( @locale )
      actual.should eql( { 'app_name'    => 'Kid Mode',
                           'pd_app_name' => 'Parent Dashboard',
                           'app_current' => 'current' } )
    end

  end

  describe 'current_plurals' do

    it "extracts the plural definitions from the strings file" do
      expected = { "user_count" => { "one"  => "1 user",
                                     "many" => "%d users" },
                   "fish_count" => { "one"  => "1 fish",
                                     "many" => "%d fish" } }
      Vocab::Extractor::Android.current_plurals( @locale ).should eql( expected )
    end

  end

  describe 'previous_plurals' do

    before( :each ) do
      Dir.chdir( vocab_root )
    end

    before( :each ) do
      @sha = '618e87b6a53e8fc216f046e51b1606313052bf75'
      Vocab.settings.stub!( :last_translation ).and_return( @sha )
    end

    it "extracts hash of previous string translations" do
      actual = Vocab::Extractor::Android.previous_plurals( @locale )
      actual.should eql( { "fish_count" => { "one"  => "1 fishes",
                                             "many" => "%d fish" } } )
    end

  end

  describe 'write_full' do

    it 'writes the full translation to the correct xml file' do
      strings = { 'foo' => 'bar' }
      plurals = { 'users' => { 'one'  => '1 user',
                               'other' => '2 users' } }
      Vocab::Translator::Android.should_receive( :write ).
              with( strings, plurals, "#{vocab_root}/strings.full.xml" )
      Vocab::Extractor::Android.write_full( strings, plurals )
    end

  end

  describe 'write_diff' do

    it 'writes the diff translation to the correct xml file' do
      strings = { 'foo' => 'bar' }
      plurals = { 'users' => { 'one'  => '1 user',
                               'other' => '2 users' } }
      Vocab::Translator::Android.should_receive( :write ).
              with( strings, plurals, "#{vocab_root}/strings.diff.xml" )
      Vocab::Extractor::Android.write_diff( strings, plurals )
    end

  end

  describe 'examples' do

    it 'returns file names for completed translations' do
      dir = "#{vocab_root}/spec/data/android/locales"
      actual = Vocab::Extractor::Android.examples( dir )
      actual.should include( "tmp/translations/values-es" )
    end

    it 'uses the conventional android locales directory by default' do
      Vocab::Translator::Android.should_receive( :locales ).with( "#{vocab_root}/res/values" ).and_return( [] )
      Vocab::Extractor::Android.examples
    end

  end

end