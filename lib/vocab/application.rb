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
          Vocab::Settings.create
        when "extract"
          Extractor.extract
        when "import"
          puts "this is import"
        end
      end
    end
  end
end