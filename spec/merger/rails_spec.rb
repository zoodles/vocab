require "spec_helper"
require "fileutils"

describe "Vocab::Merger::Rails" do

  it 'defaults to reasonable paths' do
    merger = Vocab::Merger::Rails.new
    merger.locales_dir.should eql( 'config/locales' )
    merger.updates_dir.should eql( 'tmp/translations' )
  end

  it 'allows custom paths' do
    locales_dir = 'custom/locales/dir'
    updates_dir = 'custom/updates/dir'
    merger = Vocab::Merger::Rails.new( locales_dir, updates_dir )
    merger.locales_dir.should eql( locales_dir )
    merger.updates_dir.should eql( updates_dir )
  end

  describe "merge_file" do

    before( :each ) do
      # Simulate config/locals files (where files are merged)
      @merge_dir = "#{vocab_root}/spec/tmp/merge"
      FileUtils.rm_rf( @merge_dir ) if File.exists?( @merge_dir )
      FileUtils.mkdir_p( @merge_dir )
      FileUtils.cp_r( "#{vocab_root}/spec/data/locales/.", @merge_dir )

      @file = "#{@merge_dir}/en.yml"
      @updates_dir = "#{vocab_root}/spec/data/translations"
      @update_file = "#{@updates_dir}/en.yml"

      merger = Vocab::Merger::Rails.new( @merge_dir, @updates_dir )
      merger.merge_file( 'en.yml' )
      @merged = YAML.load_file( @file )
    end

    it "merges updated translations" do
      @merged[:marketing][:banner].should eql('this marketing message has changed')
    end

    it "merges new translations" do
      @merged[:edu][:name].should eql('this is a new top level name')
      @merged[:models][:product][:id_56][:description].should eql('This is a new nested description')
      @merged[:models][:product][:id_56][:name].should eql('This is a new nested name')
    end

    it "retains unchanged translations" do
      @merged[:menu][:first].should eql('First menu item')
    end

    it "skips file if matching old and update file not found"

  end

end