module Vocab
  module Extractor
    class Rails < Base
      class << self
        def write_diff( diff, path )
          path ||= "#{Vocab.root}/en.yml"
          write( diff, path )
        end

        def write_full( full, path )
          path ||= "#{Vocab.root}/en.full.yml"
          write( full, path )
        end

        def write( translations, path )
          data = hasherize( translations ).to_yaml
          File.open( path, "w+" ) { |f| f.write( data ) }
          Vocab.ui.say( "Extracted to #{path}" )
        end

        def extract_previous( locales_root = "config/locales" )
          tmpdir = "#{Vocab.root}/tmp/last_translation"
          FileUtils.rm_rf( "#{tmpdir}/*" )

          sha = Vocab.settings.last_translation
          translation_files = `git ls-tree --name-only -r #{sha}:#{locales_root}`.split( "\n" )
          translation_files = translation_files.select { |f| f =~ /en.(yml|rb)$/ }
          translation_files.each do |path|
            tmpdir_path = "#{tmpdir}/#{path}"
            FileUtils.mkdir_p( File.dirname( tmpdir_path ) )
            File.open( tmpdir_path, "w+" ) do |f|
              yml = `git show #{sha}:#{locales_root}/#{path}`
              f.write( yml )
            end
          end

          return translations( tmpdir )
        end

        def extract_current( locales_root = nil )
          locales_root ||= "#{Vocab.root}/config/locales"
          return translations( locales_root )
        end

        def translations( dir )
          translator = Translator.new
          translator.load_dir( dir )
          return translator.flattened_translations( :prefix => true )
        end

        def hasherize( diff )
          translator = Vocab::Translator.new
          diff.each do |key, value|
            key = key.to_s.gsub!( /^en\./, '' )
            translator.store( key, value )
          end
          return translator.translations( :prefix => true )
        end
      end
    end
  end
end