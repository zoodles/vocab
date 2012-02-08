module Vocab
  module Extractor
    class Android < Base
      class << self

        DIFF = 'strings.diff.xml'
        FULL = 'strings.full.xml'

        def extract_current( path = nil )
          path ||= "#{Vocab.root}/res/values/strings.xml"
          return Vocab::Translator::Android.hash_from_xml( path )
        end

        def extract_previous( path = nil )
          path ||= "res/values/strings.xml"
          sha = Vocab.settings.last_translation
          xml = previous_file( path, sha )

          tmpfile = "#{Vocab.root}/tmp/last_translation/#{File.basename(path)}"
          FileUtils.mkdir_p( File.dirname( tmpfile ) )
          File.open( tmpfile, 'w' ) { |f| f.write( xml ) }
          return Vocab::Translator::Android.hash_from_xml( tmpfile )
        end

        def write_diff( diff, path = nil )
          path ||= "#{Vocab.root}/#{DIFF}"
          Vocab::Translator::Android.write( diff, path )
        end

        def write_full( diff, path = nil )
          path ||= "#{Vocab.root}/#{FULL}"
          Vocab::Translator::Android.write( diff, path )
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

      end
    end
  end
end