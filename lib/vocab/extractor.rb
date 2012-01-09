require 'i18n'

module Vocab
  class Extractor
    class << self
      def extract
        # get translations from current tree
        I18n.load_path += Dir.glob("#{Vocab.root}/config/locales/**/*.{yml,rb}")
        backend = I18n::Backend::Simple.new
        backend.send( :init_translations )
        translations = backend.send( :translations )
      end
    end
  end
end