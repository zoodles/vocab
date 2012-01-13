require "spec_helper"

describe 'Vocab::Translator' do

  describe 'load_dir' do

    before( :each ) do
      @translator = Vocab::Translator.new
      @translator.load_dir( "#{vocab_root}/spec/data/locales" )
    end

    it 'loads translations from a directory of yml files' do

      actual = @translator.translations
      expected = { :models    => { :product => { :id_125 => { :description => "Green with megawatts", :name=>"Lazer" },
                                                 :id_55  => { :description => "A new nested description", :name=>"a new nested name" },
                                                 :id_36  => { :description => "Polarized and lazer resistant", :name=>"This nested value has changed" } } },
                   :dashboard => { :chart  => "This value has changed",
                                   :details=>"This key/value has been added" },
                   :marketing => { :banner => "This product is so good" } }
      actual.should eql( expected )
    end

  end

  describe 'load_file' do

    before( :each ) do
      @file = "#{vocab_root}/spec/tmp/en.yml"
      @data = { :foo => :bar }
      @yml_hash = { :en => @data }
      File.open( @file, "w+" ) { |f| f.write( @yml_hash.to_yaml ) }
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
      expected = { :"models.product.id_125.name"       =>"Lazer",
                   :"marketing.banner"                 =>"This product is so good",
                   :"models.product.id_36.description" =>"Polarized and lazer resistant",
                   :"dashboard.details"                =>"This key/value has been added",
                   :"models.product.id_36.name"        =>"This nested value has changed",
                   :"models.product.id_55.description" =>"A new nested description",
                   :"dashboard.chart"                  =>"This value has changed",
                   :"models.product.id_125.description"=>"Green with megawatts",
                   :"models.product.id_55.name"        =>"a new nested name" }
      actual.should == expected
    end

  end

  describe 'store' do

    it 'stores translation' do
      @key = 'foo.bar'
      @value = 'baz'
      translator = Vocab::Translator.new
      translator.store( @key, @value )
      translator.flattened_translations[ @key.to_sym ].should eql( @value )
    end

  end

  describe 'fetch' do

    it 'fetch a translation' do
      @key = 'foo.bar'
      @value = 'baz'
      translator = Vocab::Translator.new
      translator.store( @key, @value )
      translator.fetch( @key ).should eql( @value )
    end

  end

end