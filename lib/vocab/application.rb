require 'optparse'
require 'ostruct'

module Vocab
  class Application
    
    class << self
      def run
        return handle_command
      end

      ##############################
      # CLI
      ##############################

      def handle_command
        success = true
        options = OpenStruct.new
        parser = OptionParser.new

        parser.banner = 'Usage: vocab [-h] command [platform] [type] [path]'
        parser.on( '-h', '--help', 'Show this usage message' ) { options.help = true }
        parser.on( '-s', '--strict', 'Require matching order of interpolations' ) { options.strict = true }
        parser.separator ""
        parser.separator "    vocab init"
        parser.separator "    vocab extract rails"
        parser.separator "    vocab extract rails all"
        parser.separator "    vocab extract android"
        parser.separator "    vocab clean rails"
        parser.separator "    vocab convert rails xml2yml <infile>"
        parser.separator "    vocab convert rails yml2xml <infile>"
        parser.separator "    vocab merge rails [-s]"
        parser.separator "    vocab merge android"
        parser.separator "    vocab validate android"
        parser.separator "    vocab validate rails"
        parser.separator "    vocab interpolation rails <file> [-s]"
        parser.separator "    vocab interpolation android <file>"
        parser.separator ""

        commands = parser.parse( ARGV )
        options.command = commands[0]
        options.platform = commands[1]
        options.type = commands[2]
        options.path = commands[3]

        if( options.command == 'init' )
          Vocab::Settings.create
        elsif( options.command == 'clean' && options.platform == 'rails' )
          Cleaner::Rails.clean
        elsif( options.command == 'clean' && options.platform == 'android' )
          Cleaner::Android.clean
        elsif( options.command == 'convert' && options.platform == 'rails' )
          if options.type == 'xml2yml'
            Converter::Rails.convert_xml_to_yml( options.path )
          elsif options.type = 'yml2xml'
            Converter::Rails.convert_yml_to_xml( options.path )
          else
            puts parser.help
          end
        elsif( options.command == 'extract' && options.platform == 'rails' )
          if options.type == 'all'
            Extractor::Rails.extract_all
          else
            Extractor::Rails.extract
          end
        elsif( options.command == 'extract' && options.platform == 'android' )
          Extractor::Android.extract
        elsif( options.command == 'merge' && options.platform == 'rails' )
          Merger::Rails.new.merge( options.strict )
        elsif( options.command == 'merge' && options.platform == 'android' )
          Merger::Android.new.merge
        elsif( options.command == 'validate' && options.platform == 'android' )
          success = Validator::Android.new.validate
        elsif( options.command == 'validate' && options.platform == 'rails' )
          success = Validator::Rails.new.validate
        elsif( options.command == 'interpolation' && options.platform == 'rails' && !options.type.nil? )
            Vocab::Merger::Rails.new.check_all_interpolations( options.type, options.strict )
        elsif( options.command == 'interpolation' && options.platform == 'android' && !options.type.nil? )
          Vocab::Merger::Android.new.check_all_format_strings( options.type )
        else
          puts parser.help
        end
        
        return success
      end
    end
  end
end