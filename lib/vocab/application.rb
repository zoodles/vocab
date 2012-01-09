module Vocab
  class Application

    class << self
      def run
        handle_command
      end

      def handle_command
        case ARGV.first
        when "extract"
          Extractor.extract
        when "import"
          puts "this is import"
        end

        puts "Vocab.settings.update_translation = #{Vocab.settings.update_translation}"
      end
    end

  end
end