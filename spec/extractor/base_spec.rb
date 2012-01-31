require "spec_helper"

describe "Vocab::Extractor::Base" do

  describe "diff" do

    it "finds the new keys in the current hash" do
      @current = { 1 => 2, 3 => 4 }
      @previous = { 1 => 2 }
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { 3 => 4 }
    end

    it "finds the udpated keys in the current hash" do
      @current = { 1 => 10 }
      @previous = { 1 => 2 }
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { 1 => 10 }
    end

    it "handles the hash format of the translations" do
      @current =  { :"en.marketing.banner"=>"This product is so good",
                    :"en.models.product.id_125.name"=>"This has been updated",
                    :"en.models.product.id_126.name"=>"This is new"}
      @previous = { :"en.marketing.banner"=>"This product is so good",
                    :"en.models.product.id_125.name"=>"Lazer"}
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { :"en.models.product.id_125.name"=>"This has been updated",
                       :"en.models.product.id_126.name"=>"This is new"}
    end

  end

  describe "extract" do

    before( :each ) do
      @diff_path = "#{vocab_root}/spec/tmp/en.yml"
      @full_path = "#{vocab_root}/spec/tmp/en.yml"
      File.delete( @diff_path ) if File.exists?( @diff_path )
    end

    it "extracts the strings that need to be translated into a yml file" do
      current = { 1 => 5, 3 => 4 }
      previous = { 1 => 2 }
      Vocab::Extractor::Base.should_receive( :extract_current ).and_return( current )
      Vocab::Extractor::Base.should_receive( :extract_previous ).and_return( previous )
      Vocab::Extractor::Base.should_receive( :write_diff ).with( { 1 => 5, 3 => 4 }, @diff_path )
      Vocab::Extractor::Base.should_receive( :write_full ).with( current, @full_path )
      Vocab::Extractor::Base.extract( @diff_path, @full_path )
    end

  end

  describe "previous_file" do

    before( :each ) do
      @path = "spec/data/android/locales/strings.xml"
    end

    it "returns the contents of a file from a specific git version" do
      contents = Vocab::Extractor::Base.previous_file( @path, 'a19f7c5c28c1158792a966c0d2153a04490dd35e' )
      should_eql_file( contents, 'spec/data/android/versions/strings_1.xml' )

      contents = Vocab::Extractor::Base.previous_file( @path, '0533bcd9a304cd6e74d6a56959dbcabd57b2f1b9' )
      should_eql_file( contents, 'spec/data/android/versions/strings_2.xml' )
    end

    it "returns the correct contents when a full path is specified" do
      contents = Vocab::Extractor::Base.previous_file( "#{vocab_root}/#{@path}", 'a19f7c5c28c1158792a966c0d2153a04490dd35e' )
      should_eql_file( contents, 'spec/data/android/versions/strings_1.xml' )
    end

  end

end