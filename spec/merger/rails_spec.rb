require "spec_helper"
require "fileutils"

module MergerRailsSpecHelper

  def clear_merge_dir
    @merge_dir = "#{vocab_root}/spec/tmp/merge"
    FileUtils.rm_rf( @merge_dir ) if File.exists?( @merge_dir )
    FileUtils.mkdir_p( @merge_dir )
    FileUtils.cp_r( "#{vocab_root}/spec/data/locales/.", @merge_dir )
  end

end

describe "Vocab::Merger::Rails" do

  include MergerRailsSpecHelper

  it 'defaults to reasonable paths' do
    merger = Vocab::Merger::Rails.new
    merger.locales_dir.should eql( 'config/locales' )
    merger.updates_path.should eql( 'tmp/translations/en.yml' )
  end

  it 'allows custom paths' do
    locales_dir = 'custom/locales/dir'
    updates_path = 'custom/updates/dir/en.yml'
    merger = Vocab::Merger::Rails.new( locales_dir, updates_path )
    merger.locales_dir.should eql( locales_dir )
    merger.updates_path.should eql( updates_path )
  end

  describe "merge_file" do

    before( :each ) do
      clear_merge_dir

      @file = "#{@merge_dir}/en.yml"
      @update_file = "#{vocab_root}/spec/data/translations/en.yml"

      @merger = Vocab::Merger::Rails.new( @merge_dir, @update_file )
      @merger.merge_file( @file )
      @merged = YAML.load_file( @file )
    end

    it "merges updated translations" do
      @merged[:en][:marketing][:banner].should eql('this marketing message has changed')
    end

    it "ignores key accidentally introduced by the translators" do
      @merged[:en][:translator_cruft].should be( nil )
    end

    it "retains unchanged translations" do
      @merged[:en][:menu][:first].should eql('First menu item')
    end

    it "does not include translations from nested files" do
      @merged[:en][:models].should eql( nil )
    end

    it "does not include translations from other languages" do
      @merged[:en][:marketing][:banner].should_not eql( 'hola' )
    end

    it "skips file if matching old and update file not found" do
      missing = "missing_file/en.yml"
      @merger = Vocab::Merger::Rails.new( @merge_dir, @update_file )
      @merger.merge_file( missing )
      File.exists?( "#{@merge_dir}/#{missing}" ).should be_false
    end

  end

  describe "merge" do

    before( :each ) do
      clear_merge_dir
    end

    it 'merges nested files' do
      @update_file = "#{vocab_root}/spec/data/translations/en.yml"
      merger = Vocab::Merger::Rails.new( @merge_dir, @update_file )
      merger.merge

      @merged = YAML.load_file( "#{@merge_dir}/models/product/en.yml" )
      @merged[:en][:models][:product][:id_125][:description].should eql( 'Green with megawatts' )
      @merged[:en][:models][:product][:id_125][:name].should eql( 'Lazer' )
      @merged[:en][:models][:product][:id_55][:description].should eql( 'This description changed' )
      @merged[:en][:models][:product][:id_55][:name].should eql( 'a new nested name' )
    end

    it 'merges non-english translations' do
      @update_file = "#{vocab_root}/spec/data/translations/es.yml"
      merger = Vocab::Merger::Rails.new( @merge_dir, @update_file )
      merger.merge

      puts "@merged = #{@merged.inspect}"
      @merged[:es][:marketing][:product][:banner].should eql( 'hola mi amigo' )
      @merged[:en][:marketing][:dashboard][:chart][:name].should eql( 'Es muy bonita' )
    end

  end

  describe 'write_file' do

    it 'writes translations to a file'

  end

end