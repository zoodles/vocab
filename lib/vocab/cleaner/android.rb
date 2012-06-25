module Vocab
  module Cleaner
    class Android < Base
      class << self
        def clean_file( file )
          # TODO: implement
        end

        def files_to_clean
          return Dir.glob( "*.full.xml" )
        end
      end
    end
  end
end