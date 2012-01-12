module Vocab
  module Merger
    class Rails

      attr_accessor :data, :data_path, :locales_path

      def initialize( data_path = nil, locales_path = nil )
        @data_path = data_path || 'tmp/translations.yml'
        @locales_path = locales_path || 'config/locales'
      end

      def load
        @data = YAML.load_file( @data_path )
      end

    end
  end
end