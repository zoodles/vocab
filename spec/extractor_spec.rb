require "spec_helper"

describe "extractor" do

  describe "previous" do

    before( :each ) do
      @last_translation = '78e858925c253114b6bde95cbb0df590d184a70a'
      @locales_root = "spec/data/locals"
      @config_root = ""
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

    it "" do

    end

  end

end