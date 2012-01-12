require "spec_helper"

describe 'Vocab::Translator' do

  describe 'load_dir' do

    it 'loads translations from a directory of yml files' do
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

  end

end