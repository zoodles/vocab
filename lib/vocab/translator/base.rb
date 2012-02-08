module Vocab
  module Translator
    class Base

      def self.ignore_key?( key )
        return true if key.to_s.start_with?( 'debug_' )
        return false
      end

    end
  end
end