require 'optparse'

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
        when "extract_android"
          Extractor::Android.extract
        when "extract_rails"
          Extractor::Rails.extract
        when "merge_android"
          Merger::Android.new.merge
        when "merge_rails"
          Merger::Rails.new.merge
        else
          puts usage
        end
      end

      def init
        Vocab::Settings.create
      end

      def usage
<<-EOS
  Usage: vocab [-v] [-h] command

      -h, --help       Print this help.

      extract_rails    Extract English strings that need translation from yml files
      extract_android  Extract English strings that need translation from strings.xml
      merge_rails      Merge translations from tmp/translations into config/locales yml files
EOS
      end
    end
  end
end