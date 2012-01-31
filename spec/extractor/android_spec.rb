require "spec_helper"

describe "Vocab::Extractor::Android" do

  before( :each ) do
    @locale = "#{vocab_root}/spec/data/android/locales/strings.xml"
  end

  describe 'extract_current' do

    it "extracts hash of current string translations" do
      actual = Vocab::Extractor::Android.extract_current( @locale )
      actual.should eql( { "app_name"   =>"Kid Mode",
                           "delete"     =>"Delete",
                           "cancel"     =>"Cancel",
                           "app_current"=>"current",
                           "pd_app_name"=>"Parent Dashboard" } )
    end

  end

  #describe 'extract_current' do
  #
  #  it "extracts hash of current string translations" do
  #    actual = Vocab::Extractor::Android.extract_previous( @locale )
  #    actual.should eql( { 'app_name'    => 'Kid Mode',
  #                         'pd_app_name' => 'Parent Dashboard',
  #                         'app_current' => 'current' } )
  #  end
  #
  #end

end