require "spec_helper"

describe "Vocab::Extractor::Rails" do

  describe 'write_full' do

    it 'writes the full en translation to a file' do
      translation = { :en => { :full => 'translation' } }
      path = "#{vocab_root}/spec/tmp/en.full.yml"
      Vocab::Extractor::Rails.write_full( translation, {}, path )
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

  describe "extract_previous" do

    before( :each ) do
      @last_translation = '5ab8cf4d081d7ba1d5f020118dd00c3ea2d0437a'
      @locales_root = "spec/data/rails/locales"
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

    it 'creates a tmp folder if one does not exist' do
      dir = "#{vocab_root}/tmp/last_translation"
      FileUtils.rm_rf( "#{vocab_root}/tmp/last_translation" )
      Vocab::Extractor::Rails.extract_previous( @locales_root )
      File.exists?( dir ).should be_true
    end

  end

  describe "current_strings" do

    before( :each ) do
      Dir.chdir( vocab_root )
      @locales_root = "spec/data/rails/locales"
    end

    it "creates a hash of the english translation strings currently in the config" do
      actual = Vocab::Extractor::Rails.current_strings( @locales_root )
      expected = {:"en.marketing.banner"=>"This product is so good",
                  :"en.dashboard.chart"=>"This value has changed",
                  :"en.dashboard.details"=>"This key/value has been added",
                  :"en.menu.first"=>"First menu item",
                  :"en.menu.second"=>"Second menu item",
                  :"en.not_in_es"=>"This key not in spanish",
                  :"en.users.one"=>"1 user",
                  :"en.users.other"=>"%{count} users",
                  :"en.models.product.id_125.description"=>"Green with megawatts",
                  :"en.models.product.id_125.name"=>"Lazer",
                  :"en.models.product.id_36.description"=>"Polarized and lazer resistant",
                  :"en.models.product.id_36.name"=>"This nested value has changed",
                  :"en.models.product.id_55.description"=>"A new nested description",
                  :"en.models.product.id_55.name"=>"a new nested name"}
      actual.should eql( expected )
    end

  end

  describe "extract" do

    before( :each ) do
      @diff_path = "#{vocab_root}/spec/tmp/en.yml"
      @full_path = "#{vocab_root}/spec/tmp/en.full.yml"
    end

    it "extracts the strings that need to be translated into a yml file" do
      Vocab::Extractor::Rails.should_receive( :current_strings ).and_return( { :en => { 1 => 5, 3 => 4 } } )
      Vocab::Extractor::Rails.should_receive( :extract_previous ).and_return( { :en => { 1 => 2 } } )
      Vocab::Extractor::Rails.extract( @diff_path, @full_path )
      YAML.load_file( @diff_path ).should == { :en => { 1 => 5, 3 => 4 } }

      File.delete( @diff_path ) if File.exists?( @diff_path )
      File.delete( @full_path ) if File.exists?( @full_path )
    end

  end

  describe "examples" do

    it 'returns the directory to put the yml files' do
      Vocab::Extractor::Rails.examples.should eql( [ "#{vocab_root}/tmp/translations" ] )
    end

  end

end