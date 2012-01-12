require "spec_helper"

describe "Vocab::Merger::Rails" do

  it 'defaults to reasonable paths' do
    merger = Vocab::Merger::Rails.new
    merger.data_path.should eql( 'tmp/translations.yml' )
    merger.locals_path.should eql( 'config/locales' )
  end

  it 'allows custom paths' do
    data_path = 'custom/data/path'
    locals_path = 'custom/locals_path/path'
    merger = Vocab::Merger::Rails.new( data_path, locals_path )
    merger.data_path.should eql( data_path )
    merger.locals_path.should eql( locals_path )
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

end