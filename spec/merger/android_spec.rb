require "spec_helper"

describe "Vocab::Merger::Android" do

  before( :each ) do
    @update_dir = "#{vocab_root}/spec/data/android/translations"
    @merge_dir = clear_merge_dir
    FileUtils.cp_r( "#{vocab_root}/spec/data/android/locales/.", @merge_dir )
  end

  it 'defaults to reasonable android paths' do
    merger = Vocab::Merger::Android.new
    merger.locales_dir.should eql( 'res' )
    merger.updates_dir.should eql( 'tmp/translations' )
  end

  it 'allows custom android paths' do
    locales_dir = 'custom/locales/dir'
    updates_dir = 'custom/updates/dir'
    merger = Vocab::Merger::Android.new( locales_dir, updates_dir )
    merger.locales_dir.should eql( locales_dir )
    merger.updates_dir.should eql( updates_dir )
  end

  describe "merge" do

    before( :each ) do
      Vocab.settings.should_receive( :update_translation )
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      @merger.merge
    end

    it 'merges non-english translations' do
      @merged = Vocab::Translator::Android.hash_from_xml( "#{@merge_dir}/values-es/strings.xml" )
      @merged['app_name'].should eql( 'Modo Niños' )
      @merged['pd_app_name'].should eql( 'el Panel para padres bien' )
      @merged['delete'].should eql( 'Eliminar' )
    end

  end

  describe 'merge_file' do

    before( :each ) do
      @file = "#{@merge_dir}/values-es/strings.xml"
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      @merger.merge_file( @file )
      @merged = Vocab::Translator::Android.hash_from_xml( @file )
      puts "@merged = #{@merged.inspect}"
    end

    it "merges updated android translations" do
      @merged['pd_app_name'].should eql( 'el Panel para padres bien' )
    end

    it "integrates new android translations" do
      @merged['cancel'].should eql( 'Cancelar' )
    end

    it "ignores key accidentally introduced by the translators into android translations" do
      @merged['translator_cruft'].should be( nil )
    end

    it "retains unchanged android translations" do
      @merged['app_name'].should eql( 'Modo Niños' )
    end

    it "does not include android translations from other languages" do
      pending( "make this work after adding another language to test data" )
      @merged['app_name'].should_not eql( '這改變了營銷信息' )
    end

  end

  describe 'english_keys' do

    it 'fetches the english keys' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      keys = [ "app_name", "delete", "cancel", "app_current", "pd_app_name" ]
      merger.english_keys.should eql( keys )
    end

  end

  describe 'current_for_locale' do

    it 'returns hash of the current translations that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      expected = { "app_name"   =>"Modo Ni\303\261os",
                   "app_current"=>"actual",
                   "pd_app_name"=>"el Panel para padres"}
      merger.current_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'updates' do

    it 'returns hash of the updates that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      expected = { 'cancel'           => 'Cancelar',
                   'delete'           => 'Eliminar',
                   'pd_app_name'      => 'el Panel para padres bien',
                   'translator_cruft' => 'Malo' }
      merger.updates_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'translation_locales' do

    it 'returns the locales in the android updates directory' do
      merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      merger.translation_locales.sort.should eql( [ 'es' ] )
    end

    it 'ignores res/values directories that are not translations'

  end

  describe 'files_to_merge' do

    before ( :each ) do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
    end

    it 'returns an array of files for translation' do
      expected = ["#{@merge_dir}/values-es/strings.xml"]
      @merger.files_to_merge.sort.should eql( expected )
    end

  end

end