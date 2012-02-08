require "spec_helper"

describe 'Vocab::Translator::Android' do

  describe 'english_keys' do

    it 'returns the english keys for a locales dir' do
      locales_dir = "#{vocab_root}/spec/data/android/locales"
      expected = ["app_name", "delete", "cancel", "app_current", "not_in_es", "pd_app_name"]
      Vocab::Translator::Android.english_keys( locales_dir ).should =~ expected
    end

  end

  describe 'locales' do

    it 'returns the locales in the android updates directory' do
      dir = "#{vocab_root}/spec/data/android/translations"
      Vocab::Translator::Android.locales( dir, false ).should eql( [ 'es' ] )
    end

  end

end