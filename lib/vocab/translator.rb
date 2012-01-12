module Vocab
  class Translator

    def load_dir( dir )
      I18n.load_path = Dir.glob( "#{dir}/**/*.{yml,rb}" )
      load_translations
    end

    def translations
      return @backend.send( :translations )
    end

  private

    def load_translations
      @backend = I18n::Backend::Simple.new
      @backend.reload!
      @backend.send( :init_translations )
    end

  end
end