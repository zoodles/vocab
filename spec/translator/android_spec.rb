require "spec_helper"

describe 'Vocab::Translator::Android' do

  describe 'string_keys' do

    it 'returns the english keys for a locales dir' do
      locales_dir = "#{vocab_root}/spec/data/android/locales"
      expected = ["app_name", "delete", "cancel", "app_current", "not_in_es", "pd_app_name"]
      Vocab::Translator::Android.string_keys( locales_dir ).should =~ expected
    end

  end

  describe 'locales' do

    it 'returns the locales in the android updates directory' do
      dir = "#{vocab_root}/spec/data/android/translations"
      Vocab::Translator::Android.locales( dir, false ).should eql( [ 'es' ] )
    end

  end

  describe 'write' do

    it 'writes the strings to a xml file' do
      strings = { 'app_name'    => 'Kid Mode',
                  'pd_app_name' => 'Parent Dashboard',
                  'delete'      => "La funci&#xF3;n Child Lock",
                  'apostrophe'  => "Translator\\'s evil apostrophe don\\'t care"}
      plurals = {}
      path = "#{vocab_root}/spec/tmp/strings.xml"
      Vocab::Translator::Android.write( strings, plurals, path )
      strings = File.open( path ) { |f| f.read }
      strings.should eql_file( "spec/data/android/write.xml" )
      File.delete( path )
    end

    it 'writes the strings and plurals to a xml file' do
      strings = { 'app_name' => 'Kid Mode',
                  'pd_app_name' => 'Parent Dashboard',
                  'delete' => "La funci&#xF3;n Child Lock" }
      plurals = { 'users' => { 'one'  => '1 user',
                               'other' => '2 users' },
                  'deer'  => { 'one'  => '1 deer',
                               'other' => '2 deer' } }
      path = "#{vocab_root}/spec/tmp/strings.xml"
      Vocab::Translator::Android.write( strings, plurals, path )
      strings = File.open( path ) { |f| f.read }
      strings.should eql_file( "spec/data/android/write_plurals.xml" )
      File.delete( path )
    end

  end

  describe 'android resource special cases' do

    it "escapes apostrophes to be compatible with android resources" do
      hash = Vocab::Translator::Android.hash_from_xml( "#{vocab_root}/spec/data/android/translations/values-es/es-string-file.xml" )
      hash['apostrophe'].should eql( %q[Translator\'s evil apostrophe don\'t care] )


    end

  end

end