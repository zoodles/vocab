# encoding: UTF-8

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
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      @merger.merge
    end

    it 'merges non-english translations' do
      @merged = Vocab::Translator::Android.hash_from_xml( "#{@merge_dir}/values-es/strings.xml" )
      @merged['app_name'].should eql( 'Modo Niños' )
      @merged['pd_app_name'].should eql( 'el Panel para padres bien' )
      @merged['delete'].should eql( "La función Child Lock" )
    end
  end

  describe "check_matching_format_strings" do
    it 'warns about format string changes in singular strings' do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      Vocab.ui.should_receive( :warn ).with( "Format string mismatch for key delete while merging #{@merge_dir}/values-fr/strings.xml. \n English: Delete %1$d \n Translation: Deletee %2$d\n\n" )
      @merger.check_matching_format_strings( 'delete', "Deletee %2$d", "#{@merge_dir}/values-fr/strings.xml", :string_format_changed? ) 
    end

    it 'warns about format string changes in plurals' do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      Vocab.ui.should_receive( :warn ).with( "Format string mismatch for key user_count, quantity many while merging #{@merge_dir}/values-fr/strings.xml. \n English: %d users \n Translation: %f users\n\n" )
      @merger.check_matching_format_strings( 'user_count', {  "one" => "1 user", "many" => "%f users" }, "#{@merge_dir}/values-fr/strings.xml", :plural_format_changed? ) 
    end


    it 'does not warn about $ in currency' do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      Vocab.ui.should_not_receive( :warn )
      @merger.check_matching_format_strings( 'price', "Alles zu einem Preis von 3,50 USD pro Monat.", "#{@merge_dir}/values-fr/strings.xml", :string_format_changed? ) 
    end

    it 'does not warn about % as actual percent sign' do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      Vocab.ui.should_not_receive( :warn )
      @merger.check_matching_format_strings( 'guarantee', "Rimborso garantito al 100%!", "#{@merge_dir}/values-fr/strings.xml", :string_format_changed? ) 
    end

    it 'only checks for one character after %' do
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      Vocab.ui.should_not_receive( :warn )
      @merger.check_matching_format_strings( 'free', "%s의 주간 무료 앱!", "#{@merge_dir}/values-fr/strings.xml", :string_format_changed? ) 
    end
  end

  describe 'merge_file' do

    before( :each ) do
      @file = "#{@merge_dir}/values-es/strings.xml"
      @merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      @merger.merge_file( @file )
    end

    context "strings" do

      before( :each ) do
        @merged = Vocab::Translator::Android.hash_from_xml( @file )
      end

      it "merges updated android translations" do
        @merged['pd_app_name'].should eql( 'el Panel para padres bien' )
      end

      it "integrates new android translations" do
        @merged['cancel'].should eql( 'Cancelar' )
      end

      it "properly encodes html entities" do
        @merged['delete'].should eql( "La función Child Lock" )
      end

      it "ignores key accidentally introduced by the translators into android translations" do
        @merged['translator_cruft'].should be( nil )
      end

      it "retains unchanged android translations" do
        @merged['app_name'].should eql( 'Modo Niños' )
      end

      it 'does not include keys where there is no translation' do
        @merged['not_in_es'].should be( nil )
      end

    end

    context "strings" do

      before( :each ) do
        @merged = Vocab::Translator::Android.plurals_from_xml( @file )
      end

      it "includes plurals where an item is updated" do
        @merged[ 'fish_count' ].should eql( { 'one' => '1 pescado', 'many' => '%d peces' } )
      end

      it "includes new plural definition" do
        @merged[ 'user_count' ].should eql( {"one"=>"1 usuario", "many"=>"%d usuarios"} )
      end
    end

  end

  describe 'string_keys' do

    it 'fetches the english keys' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      keys = ["app_name", "delete", "cancel", "app_current", "not_in_es", "pd_app_name", "free", "guarantee", "price" ]
      merger.string_keys.should =~ keys
    end

  end

  describe 'plural_keys' do

    it 'fetches the plural definition keys from the english file' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      keys = ["fish_count", "user_count"]
      merger.plural_keys.should =~ keys
    end

  end

  describe 'current_strings_for_locale' do

    it 'returns hash of the current translations that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      expected = { "app_name"   =>"Modo Niños",
                   "app_current"=>"actual",
                   "pd_app_name"=>"el Panel para padres"}
      merger.current_strings_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'update_strings_for_locale' do

    it 'returns hash of the updates that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      expected = { 'cancel'           => 'Cancelar',
                   'delete'           => "La función Child Lock",
                   'pd_app_name'      => 'el Panel para padres bien',
                   'translator_cruft' => 'Malo',
                   'apostrophe'       => "Translator\\'s evil apostrophe don\\'t care" }
      merger.update_strings_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'current_plurals_for_locale' do

    it 'returns hash of the current translations that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      expected = { "fish_count" => { "one" => "1 pescado", "many" => "%d peces" } }
      merger.current_plurals_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'update_plurals_for_locale' do

    it 'returns hash of the updates that match a locale file' do
      merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      expected = { "user_count" => { "one" => "1 usuario", "many" => "%d usuarios" },
                   "fish_count" => { "one" => "1 pescado", "many" => "%d peces" } }
      merger.update_plurals_for_locale( "#{@merge_dir}/values-es/strings.xml" ).should == expected
    end

  end

  describe 'translation_locales' do

    it 'returns the locales in the android updates directory' do
      merger = Vocab::Merger::Android.new( @merge_dir, @update_dir )
      locales = [ 'es' ]
      Vocab::Translator::Android.should_receive( :locales ).with( @update_dir, false ).and_return( locales )
      merger.translation_locales.should eql( locales )
    end

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