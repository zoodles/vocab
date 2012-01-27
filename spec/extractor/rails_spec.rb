require "spec_helper"

describe "Vocab::Extractor::Rails" do

  describe 'write_diff' do

    it 'writes the diff to the correct file'

  end

  describe 'write_full' do

    it 'writes the full en translation to a file' do
      translation = { :en => { :full => 'translation' } }
      path = "#{vocab_root}/spec/tmp/en.full.yml"
      Vocab::Extractor::Rails.write_full( translation, path )
      YAML.load_file( path ).should eql( translation )
      File.delete( path )
    end

  end

  describe 'hasherize' do

    it 'writes the diff in standard rails locale yaml format' do
      flattened = { :"en.video_mail.kid.approve"     => "To let %{kid} start sending video mail",
                    :"en.models.subject.id_125.name" => "Recording Data Stuff" }
      hash = Vocab::Extractor::Rails.hasherize( flattened )
      expected = { :en=> { :models => { :subject => { :id_125=> { :name => "Recording Data Stuff" } } },
                           :video_mail=> { :kid=>{ :approve=>"To let %{kid} start sending video mail" } } } }
      hash.should == expected
    end

  end

  describe "previous" do

    before( :each ) do
      @last_translation = 'f3e9ccaf589f54d69e55fd2200dc9a899adf459f'
      @locales_root = "spec/data/locales"
      Vocab.settings.stub!( :last_translation ).and_return( @last_translation )
      Dir.chdir( vocab_root )
    end

    it "creates a hash of the english translation strings from the last translation" do
      actual = Vocab::Extractor::Rails.extract_previous( @locales_root )
      expected = { :"en.models.product.id_36.description" =>"Polarized and lazer resistant",
                   :"en.marketing.banner"                 =>"This product is so good",
                   :"en.models.product.id_36.name"        =>"This nested value has changed",
                   :"en.menu.first"                       =>"First menu item",
                   :"en.models.product.id_55.description" =>"A new nested description",
                   :"en.models.product.id_125.description"=>"Green with megawatts",
                   :"en.dashboard.chart"                  =>"This value has changed",
                   :"en.models.product.id_55.name"        =>"a new nested name",
                   :"en.models.product.id_125.name"       =>"Lazer",
                   :"en.dashboard.details"                =>"This key/value has been added" }
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
      expected = { :"en.menu.second"                      =>"Second menu item",
                   :"en.models.product.id_36.description" =>"Polarized and lazer resistant",
                   :"en.marketing.banner"                 =>"This product is so good",
                   :"en.models.product.id_36.name"        =>"This nested value has changed",
                   :"en.menu.first"                       =>"First menu item",
                   :"en.models.product.id_55.description" =>"A new nested description",
                   :"en.models.product.id_125.description"=>"Green with megawatts",
                   :"en.dashboard.chart"                  =>"This value has changed",
                   :"en.models.product.id_55.name"        =>"a new nested name",
                   :"en.models.product.id_125.name"       =>"Lazer",
                   :"en.dashboard.details"                =>"This key/value has been added" }
      actual.should eql( expected )
    end

  end

  describe "extract" do

    before( :each ) do
      @diff_path = "#{vocab_root}/spec/tmp/en.yml"
      @full_path = "#{vocab_root}/spec/tmp/en.full.yml"
    end

    it "extracts the strings that need to be translated into a yml file" do
      Vocab::Extractor::Rails.should_receive( :extract_current ).and_return( { :en => { 1 => 5, 3 => 4 } } )
      Vocab::Extractor::Rails.should_receive( :extract_previous ).and_return( { :en => { 1 => 2 } } )
      Vocab::Extractor::Rails.extract( @diff_path, @full_path )
      YAML.load_file( @diff_path ).should == { :en => { 1 => 5, 3 => 4 } }

      File.delete( @diff_path ) if File.exists?( @diff_path )
      File.delete( @full_path ) if File.exists?( @full_path )
    end

  end

end