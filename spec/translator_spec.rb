require "spec_helper"

describe 'Vocab::Translator' do

  describe 'load_dir' do

    it 'loads translations from a directory of yml files' do
      translator = Vocab::Translator.new
      translator.load_dir( "#{vocab_root}/spec/data/locales" )
      translator.translations.should_not be_empty
    end

  end

  describe 'translations' do

    it 'returns the translations as a hash' do
      translator = Vocab::Translator.new
      translator.load_dir( "#{vocab_root}/spec/data/locales" )
      actual = translator.translations
      expected = { :en => { :models    => { :product => { :id_125 => { :description => "Green with megawatts", :name=>"Lazer"},
                                                          :id_55  => { :description => "A new nested description", :name=>"a new nested name"},
                                                          :id_36  => { :description => "Polarized and lazer resistant", :name=>"This nested value has changed"}}},
                            :dashboard => { :chart => "This value has changed",
                                            :details=>"This key/value has been added"},
                            :marketing => { :banner => "This product is so good" } } }
      actual.should eql( expected )
    end

    it "caches the translations to protect against someone swapping I18n.load_path"

  end

  describe 'flattened_translations' do

    it 'returns the translations with flattened keys' do
      translator = Vocab::Translator.new
      translator.load_dir( "#{vocab_root}/spec/data/locales" )
      actual = translator.flattened_translations
      expected = { :"en.dashboard.details"                => "This key/value has been added",
                   :"en.models.product.id_55.description" => "A new nested description",
                   :"en.models.product.id_36.name"=>"This nested value has changed",
                   :"en.models.product.id_55.name"=>"a new nested name",
                   :"en.dashboard.chart"=>"This value has changed",
                   :"en.marketing.banner"=>"This product is so good",
                   :"en.models.product.id_125.description"=>"Green with megawatts",
                   :"en.models.product.id_36.description"=>"Polarized and lazer resistant",
                   :"en.models.product.id_125.name"=>"Lazer" }
      actual.should == expected
    end

  end

end