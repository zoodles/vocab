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
        when "extract_rails"
          Extractor::Rails.extract
        when "merge_rails"
          Merger::Rails.merge
        end
      end

      def init
        Vocab::Settings.create
      end
    end
  end
end