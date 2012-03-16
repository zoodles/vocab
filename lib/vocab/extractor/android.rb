module Vocab
  module Extractor
    class Android < Base
      class << self

        DIFF = 'strings.diff.xml'
        FULL = 'strings.full.xml'

        STRINGS_XML = 'res/values/strings.xml'

        def current_strings( path = nil )
          path ||= "#{Vocab.root}/#{STRINGS_XML}"
          return Vocab::Translator::Android.hash_from_xml( path )
        end

        def previous_strings( path = nil )
          path ||= STRINGS_XML
          tmpfile = tmp_file( path )
          return Vocab::Translator::Android.hash_from_xml( tmpfile )
        end

        def current_plurals( path = nil )
          path ||= "#{Vocab.root}/#{STRINGS_XML}"
          return Vocab::Translator::Android.plurals_from_xml( path )
        end

        def previous_plurals( path = nil )
          path ||= STRINGS_XML
          tmpfile = tmp_file( path )
          return Vocab::Translator::Android.plurals_from_xml( tmpfile )
        end

        def write_diff( strings, plurals, path = nil )
          path ||= "#{Vocab.root}/#{DIFF}"
          Vocab::Translator::Android.write( strings, plurals, path )
        end

        def write_full( strings, plurals, path = nil )
          path ||= "#{Vocab.root}/#{FULL}"
          Vocab::Translator::Android.write( strings, plurals, path )
        end

        def examples( locales_dir = nil )
          locales_dir ||= "#{Vocab.root}/res/values"
          return Vocab::Translator::Android.locales( locales_dir ).collect do |locale|
            "tmp/translations/values-#{locale}"
          end
        end

        def print_instructions( values = {} )
          values[ :diff ] = DIFF
          values[ :full ] = FULL
          values[ :tree ] = <<-EOS
tmp/translations/values-es/strings.xml
tmp/translations/values-zh-rCN/strings.xml
          EOS

          super( values )
        end

        def tmp_file( path )
          sha = Vocab.settings.last_translation
          xml = previous_file( path, sha )
          tmpfile = "#{Vocab.root}/tmp/last_translation/#{File.basename(path)}"
          FileUtils.mkdir_p( File.dirname( tmpfile ) )
          File.open( tmpfile, 'w' ) { |f| f.write( xml ) }
          return tmpfile
        end

      end
    end
  end
end