require "spec_helper"

describe "init" do

  before( :each ) do
    @tmpdir = File.join( vocab_root, "spec", "tmp" )
    FileUtils.rm_rf( Dir.glob( "#{@tmpdir}/*" ) )
    Dir.chdir( @tmpdir )
  end

  it "creates a .vocab file if one doesn't exist" do
    Vocab.ui.should_receive( :say ).with( "Writing new .vocab file.  Check this file into your project repo" )
    Vocab::Settings.create
    path = "#{@tmpdir}/.vocab"
    File.exists?( path ).should be_true
    YAML.load_file( path ).should == { "last_translation" => `git rev-parse HEAD`.strip }
    `git rm -f #{path}`
  end

end