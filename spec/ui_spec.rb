require "spec_helper"

describe "UI" do

  describe 'warn' do

    it 'prepends a warning message to output' do
      message = "there is a problem"
      Vocab.ui.should_receive( :say ).with( "Warning: #{message}" )
      Vocab.ui.warn( message )
    end

  end

end