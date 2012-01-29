# Warning: this object has some sharp edges because it is an unusual use of the i18n gem
# For example:
#   - we are calling private methods
#   - instances share the I18n.load_path, which could lead to unexpected behavior

module Vocab
  class Translator

    attr_accessor :locale

    def initialize( locale = :en )
      @backend = I18n::Backend::Simple.new
      @locale = locale
    end

    def load_dir( dir )
      I18n.load_path = Dir.glob( "#{dir}/**/*.{yml,rb}" )
      load_translations
    end

    def load_file( file )
      @locale = File.basename( file ).gsub( /\..*$/, '' ).to_sym
      I18n.load_path = [ file ]
      load_translations
    end

    def write_file( file )
      yaml = { @locale => self.translations }.to_yaml
      File.open( file, 'w+' ) { |f| f.write( yaml ) }
    end

    def translations( options = {} )
      t = @backend.send(:translations)
      trans = t[ @locale ]
      return options[ :prefix ] == true ? { @locale => trans } : trans
    end

    def flattened_translations( options = {} )
      return @backend.flatten_translations( @locale, translations( options ), true, false )
    end

    def store( key, value )
      keys = I18n.normalize_keys( @locale, key, [], nil)
      keys.shift # remove locale
      data = keys.reverse.inject( value ) { |result, _key| { _key => result } }
      @backend.store_translations( @locale, data )
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