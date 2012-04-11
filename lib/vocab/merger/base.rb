module Vocab
  module Merger
    class Base

      attr_accessor :locales_dir, :updates_dir

      def merge
        files_to_merge.each do |file|
          Vocab.ui.say( "Merging file: #{file}" )
          merge_file( file )
        end
      end
    end
  end
end