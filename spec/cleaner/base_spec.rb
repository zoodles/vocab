require "spec_helper"

describe "Vocab::Cleaner::Base" do

  describe 'clean' do

    it 'cleans a list of files' do
      files = [ 'es.yml', 'en.yml' ]
      Vocab::Cleaner::Base.should_receive( :files_to_clean ).and_return( files )
      
      files.each do |file|
        Vocab::Cleaner::Base.should_receive( :clean_file ).with( file )
        Vocab.ui.should_receive( :say ).with( "Cleaning file: #{file}" )
      end
      Vocab::Cleaner::Base.clean
    end

  end
end