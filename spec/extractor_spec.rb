require "spec_helper"

describe "extractor" do

  describe "previous" do

    before( :each ) do
      @last_translation = '78e858925c253114b6bde95cbb0df590d184a70a'
      @locales_root = "spec/data/locals"
      Vocab.settings.stub!( :last_translation ).and_return( @last_translation )
    end

    it "creates a hash of the english translation strings from the last translation" do
      actual = Vocab::Extractor.extract_previous( @locales_root )
      expected = { :"en.models.product.id_36.name"=>"Sunglasses",
                   :"en.marketing.banner"=>"This product is so good",
                   :"en.models.product.id_125.name"=>"Lazer",
                   :"en.dashboard.chart"=>"Growth Year over Year",
                   :"en.models.product.id_125.description"=>"Green with megawatts",
                   :"en.models.product.id_36.description"=>"Polarized and lazer resistant"}
      actual.should eql( expected )
    end

  end

  describe "current" do

    before( :each ) do
      @locales_root = "spec/data/locals"
    end

    it "creates a hash of the english translation strings currently in the config" do
      actual = Vocab::Extractor.extract_current( @locales_root )
      expected = {:"en.marketing.banner"=>"This product is so good",
                  :"en.models.product.id_125.name"=>"Lazer",
                  :"en.dashboard.details"=>"This key/value has been added",
                  :"en.dashboard.chart"=>"This value has changed",
                  :"en.models.product.id_55.description"=>"A new nested description",
                  :"en.models.product.id_125.description"=>"Green with megawatts",
                  :"en.models.product.id_55.name"=>"a new nested name",
                  :"en.models.product.id_36.description"=>"Polarized and lazer resistant",
                  :"en.models.product.id_36.name"=>"This nested value has changed"}
      actual.should eql( expected )
    end

  end

end