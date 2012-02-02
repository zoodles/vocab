require "spec_helper"

describe "Vocab::Merger::Android" do

  before( :each ) do
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

  describe 'merge_file' do

    it '' do

    end

  end

  describe 'english_keys' do

    it 'fetches the english keys' do
      merger = Vocab::Merger::Android.new( @merge_dir )
      keys = [ "app_name", "delete", "cancel", "app_current", "pd_app_name" ]
      merger.english_keys.should eql( keys )
    end

  end

end