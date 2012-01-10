module Vocab
  class Application

    class << self
      def run
        handle_command
      end

      ##############################
      # CLI
      ##############################

      def handle_command
        case ARGV.first
        when "init"
          init
        when "extract"
          Extractor.extract
        when "import"
          puts "this is import"
        end

        puts "Vocab.settings.update_translation = #{Vocab.settings.update_translation}"
      end
    end

    def init
      puts "Writing new .vocab file"
      Settings.update_translation
      Settings.write_settings
    end
  end
end