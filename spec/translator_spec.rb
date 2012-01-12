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

  describe 'load_file' do

    before( :each ) do
      @file = "#{vocab_root}/spec/tmp/en.yml"
      @data = { :en => { :foo => :bar } }
      File.open( @file, "w+" ) { |f| f.write( @data.to_yaml ) }
    end

    it 'loads translations from a yml file' do
      translator = Vocab::Translator.new
      translator.load_file( @file )
      translator.translations.should == @data
    end

  end

  describe 'translations' do

    before( :each ) do
      @file_1 = "#{vocab_root}/spec/tmp/en.yml"
      @data_1 = { :en => { :foo => :bar } }
      File.open( @file_1, "w+" ) { |f| f.write( @data_1.to_yaml ) }

      @file_2 = "#{vocab_root}/spec/tmp/en2.yml"
      @data_2 = { :en => { :yee => :hah } }
      File.open( @file_2, "w+" ) { |f| f.write( @data_2.to_yaml ) }
    end

    it 'caches the translations to protect against someone swapping I18n.load_path' do
      translator_1 = Vocab::Translator.new
      translator_1.load_file( @file_1 )
      data_1 = translator_1.translations

      # Implicitly changes the I18n.load_path
      translator_2 = Vocab::Translator.new
      translator_2.load_file( @file_2 )

      translator_1.translations.should eql( data_1 )
    end

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