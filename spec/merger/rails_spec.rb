require "spec_helper"
require "fileutils"

describe "Vocab::Merger::Rails" do

  def init_merge_dir
    @merge_dir = clear_merge_dir
    FileUtils.cp_r( "#{vocab_root}/spec/data/locales/.", @merge_dir )
    return @merge_dir
  end

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
      init_merge_dir
      @file = "#{@merge_dir}/es.yml"
      @update_dir = "#{vocab_root}/spec/data/translations"

      @merger = Vocab::Merger::Rails.new( @merge_dir, @update_dir )
      @merger.merge_file( @file )
      @merged = YAML.load_file( @file )
    end

    it "merges updated translations" do
      @merged[:es][:marketing][:banner].should eql( 'hola mi amigo' )
    end

    it "ignores key accidentally introduced by the translators" do
      @merged[:es][:translator_cruft].should be( nil )
    end

    it "retains unchanged translations" do
      @merged[:es][:dashboard][:chart].should eql( 'Es muy bonita' )
    end

    it "does not include translations from nested files" do
      @merged[:es][:models].should eql( nil )
    end

    it "does not include translations from other languages" do
      @merged[:es][:marketing][:banner].should_not eql( '這改變了營銷信息' )
    end

  end

  describe "create_file" do

    before( :each ) do
      init_merge_dir
      @file = "#{@merge_dir}/cn.yml"
      @update_dir = "#{vocab_root}/spec/data/translations"
    end

    it "creates a file for missing translations" do
      File.exists?( @file ).should be_false
      @merger = Vocab::Merger::Rails.new( @merge_dir, @update_dir )
      @merger.merge_file( @file )
      File.exists?( @file ).should be_true

      @merged = YAML.load_file( @file )
      @merged[:cn][:marketing][:banner].should eql( '這改變了營銷信息' )
      @merged[:cn][:translator_cruft].should eql( nil )
    end

  end

  describe "merge" do

    before( :each ) do
      init_merge_dir
      @update_dir = "#{vocab_root}/spec/data/translations"
      Vocab.settings.should_receive( :update_translation )
      @merger = Vocab::Merger::Rails.new( @merge_dir, @update_dir )
      @merger.merge
    end

    it 'merges nested files' do
      @merged = YAML.load_file( "#{@merge_dir}/models/product/es.yml" )
      @merged[:es][:models][:product][:id_125][:description].should eql( 'mucho Verde' )
      @merged[:es][:models][:product][:id_125][:name].should eql( 'mucho Lazero' )
      @merged[:es][:models][:product][:id_55][:description].should eql( 'Azul' )
      @merged[:es][:models][:product][:id_55][:name].should eql( 'Muy bonita' )
    end

    it 'merges non-english translations' do
      @merged = YAML.load_file( "#{@merge_dir}/es.yml" )
      @merged[:es][:marketing][:banner].should eql( 'hola mi amigo' )
      @merged[:es][:dashboard][:chart].should eql( 'Es muy bonita' )
      @merged[:es][:menu][:first].should eql( 'Uno' )
    end

  end

  describe 'write_file' do

    it 'writes translations to a file'

  end

  describe "keys_for_file" do

    it "returns the keys that should be in a file" do
      path = "#{vocab_root}/spec/data/locales/es.yml"
      actual = Vocab::Merger::Rails.keys_for_file( path )
      expected = [:"dashboard.details", :"menu.first", :"dashboard.chart", :"menu.second", :"marketing.banner"]
      actual.each { |key| expected.should include( key ) }
      actual.size.should eql( expected.size )
    end

  end

  describe "translatable?" do

    before( :each ) do
      @merger = Vocab::Merger::Rails.new
    end

    it "doesn't translate english files because that should be the reference language anyway" do
      @merger.translatable?( "#{vocab_root}/spec/data/locales/es.yml" ).should be_true
      @merger.translatable?( "#{vocab_root}/spec/data/locales/en.yml" ).should be_false
    end

    it "doesn't translate files that don't have equivalent en.yml reference file"

    it "ignores files that don't have matching filename and contents" do
      spanish_file = "#{vocab_root}/spec/tmp/es.yml"
      english_file = Vocab::Merger::Rails.en_equivalent_path( spanish_file )
      english_contents = { :en => { :english => 'stuff here' } }
      File.open( spanish_file, 'w+' ) { |file| file.write( english_contents.to_yaml ) }
      File.open( english_file, 'w+' ) { |file| file.write( english_contents.to_yaml ) }
      Vocab.ui.should_receive( :say ).with( 'File extension does not match file contents' )
      @merger.translatable?( spanish_file ).should be_false
      File.delete( spanish_file ) if File.exists?( spanish_file )
      File.delete( english_file ) if File.exists?( english_file )
    end

  end

  describe 'translation_locales' do

    before ( :each ) do
      @updates_dir = "#{vocab_root}/spec/data/translations"
      @merger = Vocab::Merger::Rails.new
      @merger.updates_dir = @updates_dir
    end

    it 'returns a list of locales in the translations' do
      @merger.translation_locales.sort.should eql( [ 'cn', 'es' ] )
    end

  end

  describe 'files_to_merge' do

    before ( :each ) do
      @locales_dir = "#{vocab_root}/spec/data/locales"
      @updates_dir = "#{vocab_root}/spec/data/translations"
      @merger = Vocab::Merger::Rails.new( @locales_dir, @updates_dir )
    end

    it 'returns an array of files for translation' do
      expected = ["#{@locales_dir}/cn.yml",
                  "#{@locales_dir}/es.yml",
                  "#{@locales_dir}/models/product/cn.yml",
                  "#{@locales_dir}/models/product/es.yml"]
      @merger.files_to_merge.sort.should eql( expected )
    end

  end

end