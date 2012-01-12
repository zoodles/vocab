require "spec_helper"

describe "Vocab::Merger::Rails" do

  it 'defaults to reasonable paths' do
    merger = Vocab::Merger::Rails.new
    merger.data_path.should eql( 'tmp/translations.yml' )
    merger.locales_path.should eql( 'config/locales' )
  end

  it 'allows custom paths' do
    data_path = 'custom/data/path'
    locales_path = 'custom/locales_path/path'
    merger = Vocab::Merger::Rails.new( data_path, locales_path )
    merger.data_path.should eql( data_path )
    merger.locales_path.should eql( locales_path )
  end

  describe "load" do

    before( :each ) do
      @data_path = 'spec/data/translations/en.yml'
    end

    it "loads the new translations" do
      merger = Vocab::Merger::Rails.new( @data_path )
      merger.load
      expected = { "en" => { "edu" => { "name"=>"this is a new top level name"},
                             "models"=>{"product"=>{"id_55"=>{:description=>"This description changed", :name=>"a new nested name"},
                                                    "id_56"=>{:description=>"This is a new nested description", :name=>"This is a new nested name"}}},
                             "marketing"=>{"banner"=>"this marketing message has changed"}}}
      merger.data.should == expected
    end

  end

  describe "merge_file" do

    before( :each ) do
      @data_path = 'spec/data/translations/en.yml'
      @file = "#{vocab_root}/spec/tmp/en.yml"
      old = { 'en' => { 'dashboard' => { 'headline' => 'welcome!' } },
                        'edu'       => { 'subject'   => 'math' } }
      File.open( @file, "w+" ) { |f| f.write( old.to_yaml ) }
    end

    it "merges a single file" do
      merger = Vocab::Merger::Rails.new
      merger.data = { 'en' => { 'dashboard' => { 'headline' => 'Really welcome!' } },
                                'foo'       => { 'bar'      => 'baz' } }
      merger.merge_file( @file )
      actual = YAML.load_file( @file )
      expected = { 'en' => { 'dashboard' => { 'headline' => 'Really welcome!' } },
                             'edu'       => { 'subject'   => 'math' },
                             'foo'       => { 'bar'      => 'baz' } }
      actual.should eql( expected )
    end

  end

end