module Vocab
  module Cleaner
    class Base
      class << self
        def clean
          files_to_clean.each do |file|
            Vocab.ui.say( "Cleaning file: #{file}" )
            clean_file( file )
          end
        end
      end
    end
  end
end