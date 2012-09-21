module Vocab
  module Merger
    class Base

      attr_accessor :locales_dir, :updates_dir

      def merge( strict = false )
        files_to_merge.each do |file|
          Vocab.ui.say( "Merging file: #{file}" )
          merge_file( file, strict )
        end
      end
    end
  end
end