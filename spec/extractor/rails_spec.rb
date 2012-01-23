require "spec_helper"

describe "Vocab::Extractor::Rails" do

  describe "previous" do

    before( :each ) do
      @last_translation = '78e858925c253114b6bde95cbb0df590d184a70a'
      @locales_root = "spec/data/locales"
      Vocab.settings.stub!( :last_translation ).and_return( @last_translation )
      Dir.chdir( vocab_root )
    end

    it "creates a hash of the english translation strings from the last translation" do
      actual = Vocab::Extractor::Rails.extract_previous( @locales_root )
      expected = { :"models.product.id_36.name"=>"Sunglasses",
                   :"marketing.banner"=>"This product is so good",
                   :"models.product.id_125.name"=>"Lazer",
                   :"dashboard.chart"=>"Growth Year over Year",
                   :"models.product.id_125.description"=>"Green with megawatts",
                   :"models.product.id_36.description"=>"Polarized and lazer resistant"}
      actual.should eql( expected )
    end

  end

  describe "current" do

    before( :each ) do
      Dir.chdir( vocab_root )
      @locales_root = "spec/data/locales"
    end

    it "creates a hash of the english translation strings currently in the config" do
      actual = Vocab::Extractor::Rails.extract_current( @locales_root )
      expected = { :"models.product.id_125.description"=>"Green with megawatts",
                   :"models.product.id_36.description" =>"Polarized and lazer resistant",
                   :"menu.first"                       =>"First menu item",
                   :"models.product.id_36.name"        =>"This nested value has changed",
                   :"dashboard.details"                =>"This key/value has been added",
                   :"marketing.banner"                 =>"This product is so good",
                   :"models.product.id_55.description" =>"A new nested description",
                   :"models.product.id_125.name"       =>"Lazer",
                   :"models.product.id_55.name"        =>"a new nested name",
                   :"dashboard.chart"                  =>"This value has changed" }
      actual.should eql( expected )
    end

  end

  describe "extract" do

    before( :each ) do
      @path = "#{vocab_root}/spec/tmp/en.yml"
      File.delete( @path ) if File.exists?( @path )
    end

    it "extracts the strings that need to be translated into a yml file" do
      Vocab::Extractor::Rails.should_receive( :extract_current ).and_return( { 1 => 5, 3 => 4 } )
      Vocab::Extractor::Rails.should_receive( :extract_previous ).and_return( { 1 => 2 } )
      Vocab::Extractor::Rails.extract( @path )
      YAML.load_file( @path ).should == { 1 => 5, 3 => 4 }
    end

  end

end