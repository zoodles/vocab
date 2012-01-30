module Vocab
  module Merger
    class Android < Base

      def merge
        Vocab.ui.say( 'Implement me in lib/vocab/merger/android.rb' )
        # integrate the translations from tmp/translations into the relevant strings.xml files
        #  - add updates to existing translations
        #  - write whole files to new translations
      end

    end
  end
end