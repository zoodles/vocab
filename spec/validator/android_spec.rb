require "spec_helper"

describe "Vocab::Validator::Android" do

  before( :each ) do
    @locales_dir = "#{vocab_root}/spec/data/android/locales"
    @validator = Vocab::Validator::Android.new( @locales_dir )
  end

  describe 'validate_file' do

    before( :each ) do
      @path = "#{vocab_root}/spec/data/android/locales/values-es/strings.xml"
    end

    it 'returns a hash containing the missing keys' do
      result = @validator.validate_file( @path )
      result[ :missing ].should eql( [ "cancel", "delete", "not_in_es" ] )
    end

    it 'returns a hash containing the extra keys' do
      spanish = { 'foo' => 'bar', 'extra' => 'coffee', 'stuff' => 'clutter' }
      Vocab::Translator::Android.should_receive( :hash_from_xml ).and_return( spanish )
      @validator.should_receive( :english_keys ).at_least(:once).and_return( [ 'foo' ] )

      result = @validator.validate_file( @path )
      result[ :extra ].should eql( [ 'extra', 'stuff' ] )
    end

  end

  describe 'files_to_validate' do

    it 'returns the locale files to validate' do
      files = [ "#{@locales_dir}/values-es/strings.xml" ]
      @validator.files_to_validate.should eql( files )
    end

  end

  describe 'validate' do

    it 'validates android locales files' do
      files = @validator.files_to_validate
      files.each { |file| @validator.should_receive( :validate_file ).with( file ) }
      @validator.should_receive( :print ).exactly( files.size ).times
      @validator.validate
    end

    it 'prints without exception' do
      @validator.validate
    end

  end

end