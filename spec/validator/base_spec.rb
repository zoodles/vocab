require "spec_helper"

describe "Vocab::Validator::Base" do
  
  describe "validate" do

    before( :each ) do
      @files = [ 'foo', 'bar' ]
      @good = { :missing => [], :extra => [] }
      @bad = { :missing => [ 'bad' ], :extra => [] }

      @validator = Vocab::Validator::Base.new
      @validator.should_receive( :files_to_validate ).and_return( @files )
    end
    
    it "returns true if no files have missing keys" do
      @validator.should_receive( :validate_file ).exactly( @files.size ).times.and_return( @good )
      @validator.validate.should be_true
    end
          
    it "returns false if any files have missing keys" do
      @validator.should_receive( :validate_file ).exactly( @files.size ).times.and_return( @bad )
      @validator.validate.should be_false  
    end

    it "returns false if the pre_validate fails" do
      @validator.should_receive( :validate_file ).exactly( @files.size ).times.and_return( @good )
      @validator.should_receive( :pre_validate ).and_return( false )
      @validator.validate.should be_false
    end
    
  end

end