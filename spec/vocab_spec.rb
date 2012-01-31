require "spec_helper"

describe "Vocab" do

  describe 'root' do

    it 'returns the root of the gem' do
      Vocab.root.should =~ /vocab$/
    end

  end

end