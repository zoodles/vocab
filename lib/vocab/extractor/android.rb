module Vocab
  module Extractor
    class Android < Base
      class << self

        def extract_previous
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # return a flat hash representing the key/vals from the strings.xml from the previous SHA version
        end

        def extract_current
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # return a flat hash representing the key/vals from the current strings.xml
        end

        def write_diff( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing the strings that need to be updated
        end

        def write_full( diff, path )
          Vocab.ui.say( 'Implement me in lib/vocab/extractor/android.rb' )
          # write out a strings.xml file containing all the strings for a new translation
        end

      end
    end
  end
end