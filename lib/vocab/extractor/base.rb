module Vocab
  module Extractor
    class Base
      class << self
        def extract( diff_path = nil, full_path = nil )
          all_strings = extract_current
          all_plurals = current_plurals

          updated_strings = diff( extract_previous, all_strings )
          updated_plurals = diff( previous_plurals, all_plurals )
          write_diff( updated_strings, updated_plurals, diff_path )
          write_full( all_strings, all_plurals, full_path )
          mkdir_examples
          print_instructions
        end

        # make a hash of all the translations that are new or changed in the current yml
        def diff( previous, current )
          diff = {}
          current.each do |key, value|
            next if Vocab::Translator::Base.ignore_key?( key )

            previous_value = previous[ key ]
            if( previous_value.nil? || previous_value != value )
              diff[ key ] = value
            end
          end
          return diff
        end

        def extract_previous
          raise "extract_previous not implemented"
        end

        def extract_current
          raise "extract_current not implemented"
        end

        def current_plurals
          raise "current_plurals not implemented"
        end

        def previous_plurals
          raise "previous_plurals not implemented"
        end

        def write_diff( diff, plurals, path )
          raise "write_diff not implemented"
        end

        def write_full( diff, plurals, path )
          raise "write_full not implemented"
        end

        def previous_file( path, sha )
          path = git_path( path )
          return `cd #{Vocab.root} && git show #{sha}:#{path}`
        end

        def git_root
          return `git rev-parse --show-toplevel`.strip
        end

        def git_path( path )
          return File.expand_path( path ).gsub( "#{git_root}/", '' )
        end

        def mkdir_examples
          examples.each do |example|
            Vocab.ui.say( "Creating placeholder: #{example}" )
            FileUtils.mkdir_p( example )
          end
        end

        def print_instructions( values = {} )
instructions = <<-EOS

Extraction completed. To complete the translation:

1. Send the language files to the translators:

#{values[:diff]} for languages that are already in the app
#{values[:full]} for languages that need a complete translation

2. To integrate new translations:

Place completed translations under tmp/translations, for example:

#{values[:tree]}

3. Merge translations into the project with:

vocab merge rails

EOS
          Vocab.ui.say( instructions )
        end

      end
    end
  end
end