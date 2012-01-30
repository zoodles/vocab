module Vocab
  module Merger
    class Base
      def update_settings
        sha = Vocab.settings.update_translation
        Vocab.ui.say( "Updated current translation to #{sha}" )
      end

      def merge
        raise "not implemented"
      end
    end
  end
end