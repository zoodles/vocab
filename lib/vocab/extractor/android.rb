module Vocab
  module Extractor
    class Android < Base
      class << self

        def extract_current( path = nil )
          raise "Invalid path to strings.xml" unless path && File.exists?( path )
          return Vocab::Translator::Android.hash_from_xml( path )
        end

        def extract_previous( path = nil )
          raise "Invalid path to strings.xml" unless path && File.exists?( path )
          sha = Vocab.settings.last_translation
          xml = previous_file( path, sha )

          tmpfile = "#{Vocab.root}/tmp/last_translation/#{File.basename(path)}"
          FileUtils.mkdir_p( File.dirname( tmpfile ) )
          File.open( tmpfile, 'w' ) { |f| f.write( xml ) }
          return Vocab::Translator::Android.hash_from_xml( tmpfile )
        end

        def write_diff( diff, path = nil )
          path ||= "#{Vocab.root}/strings.diff.xml"
          Vocab::Translator::Android.write( diff, path )
        end

        def write_full( diff, path = nil )
          path ||= "#{Vocab.root}/strings.full.xml"
          Vocab::Translator::Android.write( diff, path )
        end

      end
    end
  end
end