require "spec_helper"

describe "init" do

  before( :each ) do
    @tmpdir = File.join( vocab_root, "spec", "tmp" )
    FileUtils.rm( Dir.glob( "#{@tmpdir}/*" ) )
    Dir.chdir( @tmpdir )
  end

  it "creates a .vocab file if one doesn't exist" do
    Vocab::Application.init
    path = "#{@tmpdir}/.vocab"
    File.exists?( path ).should be_true
    YAML.load_file( path ).should == { "last_translation" => `git rev-parse HEAD`.strip }
  end

end