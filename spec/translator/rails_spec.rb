require "spec_helper"

describe 'Vocab::Translator::Rails' do

  describe 'load_dir' do

    before( :each ) do
      @translator = Vocab::Translator::Rails.new
      @translator.load_dir( "#{vocab_root}/spec/data/rails/locales" )
    end

    it 'loads translations from a directory of yml files' do

      actual = @translator.translations
      expected = { :marketing=>{ :banner=>"This product is so good" },
                   :models   =>{ :product=>{ :id_125=>{ :description=>"Green with megawatts",
                                                        :name       =>"Lazer" },
                                             :id_55 =>{ :description=>"A new nested description",
                                                        :name       =>"a new nested name" },
                                             :id_36 =>{ :description=>"Polarized and lazer resistant",
                                                        :name       =>"This nested value has changed" } } },
                   :menu     =>{ :second=>"Second menu item",
                                 :first=>"First menu item" },
                   :dashboard=>{ :chart  =>"This value has changed",
                                 :details=>"This key/value has been added" },
                   :not_in_es=>"This key not in spanish" }
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
      translator = Vocab::Translator::Rails.new
      translator.load_file( @file )
      translator.translations.should == @data
    end

    it 'sets the language based on the file loaded' do
      @file = "#{vocab_root}/spec/data/rails/locales/en.yml"
      translator = Vocab::Translator::Rails.new
      translator.load_file( @file )
      translator.locale.should eql( :en )

      @file = "#{vocab_root}/spec/data/rails/locales/es.yml"
      translator = Vocab::Translator::Rails.new
      translator.load_file( @file )
      translator.locale.should eql( :es )
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
      translator_1 = Vocab::Translator::Rails.new
      translator_1.load_file( @file_1 )
      data_1 = translator_1.translations

      # Implicitly changes the I18n.load_path
      translator_2 = Vocab::Translator::Rails.new
      translator_2.load_file( @file_2 )

      translator_1.translations.should eql( data_1 )
    end

    it 'returns nil languages without a translation' do
      translator = Vocab::Translator::Rails.new
      translator.translations.should eql( nil )
    end

  end

  describe 'flattened_translations' do

    it 'returns the translations with flattened keys in english' do
      translator = Vocab::Translator::Rails.new
      translator.load_dir( "#{vocab_root}/spec/data/rails/locales" )
      actual = translator.flattened_translations
      expected = { :"dashboard.details"                =>"This key/value has been added",
                   :"models.product.id_125.name"       =>"Lazer",
                   :"models.product.id_55.name"        =>"a new nested name",
                   :"models.product.id_36.name"        =>"This nested value has changed",
                   :"menu.second"                      =>"Second menu item",
                   :"dashboard.chart"                  =>"This value has changed",
                   :"menu.first"                       =>"First menu item",
                   :"marketing.banner"                 =>"This product is so good",
                   :"models.product.id_125.description"=>"Green with megawatts",
                   :"models.product.id_55.description" =>"A new nested description",
                   :"models.product.id_36.description" =>"Polarized and lazer resistant",
                   :"not_in_es"                        =>"This key not in spanish" }
      actual.should == expected
    end

    it 'returns the translations with flattened keys in other languages' do
      translator = Vocab::Translator::Rails.new( :es )
      translator.load_dir( "#{vocab_root}/spec/data/rails/locales" )
      actual = translator.flattened_translations
      expected = { :"models.product.id_125.name"       =>"Lazero",
                   :"marketing.banner"                 =>"hola",
                   :"models.product.id_55.name"        =>"Muy bonita",
                   :"models.product.id_125.description"=>"Verde",
                   :"models.product.id_36.name"        =>"No Lazero",
                   :"models.product.id_55.description" =>"Azul",
                   :"models.product.id_36.description" =>"Negro",
                   :"dashboard.chart"                  =>"Es muy bonita",
                   :"dashboard.details"                =>"grande" }
      actual.should == expected
    end

  end

  describe 'store' do

    it 'stores translation' do
      @key = 'foo.bar'
      @value = 'baz'
      translator = Vocab::Translator::Rails.new
      translator.store( @key, @value )
      translator.flattened_translations[ @key.to_sym ].should eql( @value )
    end

  end

  describe 'fetch' do

    it 'fetch a translation' do
      @key = 'foo.bar'
      @value = 'baz'
      translator = Vocab::Translator::Rails.new
      translator.store( @key, @value )
      translator.fetch( @key ).should eql( @value )
    end

  end

end