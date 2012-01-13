# Warning: this object has some sharp edges because it is an unusual use of the i18n gem
# For example:
#   - we are calling private methods
#   - instances share the I18n.load_path, which could lead to unexpected behavior

module Vocab
  class Translator

    def initialize
      @backend = I18n::Backend::Simple.new
    end

    def load_dir( dir )
      I18n.load_path = Dir.glob( "#{dir}/**/*.{yml,rb}" )
      load_translations
    end

    def load_file( file )
      I18n.load_path = [ file ]
      load_translations
    end

    def translations
      return @backend.send( :translations )[ :en ]
    end

    def flattened_translations
      return @backend.flatten_translations( :en, translations, true, false )
    end

    def store( key, value, locale = :en )
      keys = I18n.normalize_keys( locale, key, [], nil)
      keys.shift # remove locale
      data = keys.reverse.inject( value ) { |result, _key| { _key => result } }
      @backend.store_translations( locale, data )
    end

    def fetch( key )
      return flattened_translations[ key.to_sym ]
    end

  private

    def load_translations
      @backend.reload!
      @backend.send( :init_translations )
    end

  end
end