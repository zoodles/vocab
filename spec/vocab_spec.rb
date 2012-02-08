require "spec_helper"

describe "Vocab" do

  describe 'root' do

    it 'returns the root of the gem' do
      Vocab.root.should == File.expand_path( Dir.pwd )
    end

  end

end