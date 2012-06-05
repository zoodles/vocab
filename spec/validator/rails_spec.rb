require "spec_helper"

describe "Vocab::Validator::Rails" do

  before( :each ) do
    @locales_dir = "#{vocab_root}/spec/data/rails/locales"
    @validator = Vocab::Validator::Rails.new( @locales_dir )
  end

  describe 'pre_validate' do

    it "complains about yml files with leading BOM characters" do
      File.open( "#{@locales_dir}/bom.yml", "w+" ) { |f| f.write( "\xEF\xBB\xBF".force_encoding("UTF-8") ) }
      File.open( "#{@locales_dir}/bom.yml", "a" ) { |f| f.write( "bom:" ) }

      bom_regex = "\xEF\xBB\xBF".force_encoding("UTF-8")
      File.open( "#{@locales_dir}/bom.yml" ) { |f| f.read }.force_encoding( "UTF-8" ).match( bom_regex ).should be_true

      @validator.pre_validate( "#{@locales_dir}/bom.yml" ).should be_false
    end

  end

  describe 'validate_file' do

    before( :each ) do
      @path = "#{vocab_root}/spec/data/rails/locales/es.yml"
    end

    it 'returns a hash containing the missing keys' do
      result = @validator.validate_file( @path )
      result[ :missing ].should =~ ["menu.first", "menu.second", "not_in_es", "users.one", "users.other"]
    end

    it 'returns a hash containing the extra keys' do
      @validator.should_receive( :string_keys ).and_return( [ 'foo' ] )
      @validator.should_receive( :other_keys ).and_return( [ 'foo', 'extra', 'stuff' ] )
      result = @validator.validate_file( @path )
      result[ :extra ].should eql( [ 'extra', 'stuff' ] )
    end

  end

  describe 'files_to_validate' do

    it 'returns the locale files to validate' do
      expected = ["#{@locales_dir}/bom.yml",
                  "#{@locales_dir}/es.yml",
                  "#{@locales_dir}/models/product/es.yml"]

      actual = @validator.files_to_validate

      actual.size.should eql( expected.size )
      expected.each { |path| actual.should include( path ) }
    end

  end

  describe 'validate' do

    it 'validates android locales files' do
      files = @validator.files_to_validate
      files.each { |file| @validator.should_receive( :validate_file ).with( file ).and_return( {} ) }
      @validator.should_receive( :print ).exactly( files.size ).times
      @validator.validate
    end

    it 'prints without exception' do
      @validator.validate
    end

  end

  describe 'other_keys' do

    before( :each ) do
      @file = "#{@locales_dir}/es.yml"
      @validator = Vocab::Validator::Rails.new( @locales_dir )
    end

    it 'returns the flattened keys from the file' do
      keys = ["dashboard.chart", "dashboard.details", "marketing.banner"]
      @validator.other_keys( @file ).should =~ keys
    end

  end

  describe 'string_keys' do

    before( :each ) do
      @file = "#{@locales_dir}/es.yml"
      @validator = Vocab::Validator::Rails.new( @locales_dir )
    end

    it 'returns the flattened keys from english equivalent file' do
      keys = ["dashboard.chart", "dashboard.details", "marketing.banner", "menu.first", "menu.second", "not_in_es", "users.one", "users.other"]
      @validator.string_keys( @file ).should =~ keys
    end

  end

end