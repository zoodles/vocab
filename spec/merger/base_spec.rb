require "spec_helper"

describe "Vocab::Extractor::Base" do

  describe 'merge' do

    before( :each ) do
      @merger = Vocab::Merger::Base.new
      @merger.should_receive( :update_settings )
    end

    it 'merges a list of files' do
      files = [ 'es.yml', 'zh.yml' ]
      @merger.should_receive( :files_to_merge ).and_return( files )
      files.each do |file|
        @merger.should_receive( :merge_file ).with( file )
        Vocab.ui.should_receive( :say ).with( "Merging file: #{file}" )
      end
      @merger.merge
    end

  end

end