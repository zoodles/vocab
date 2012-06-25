module Vocab
  module Extractor
    class Rails < Base
      DIFF = 'en.yml'
      FULL = 'en.full.yml'

      class << self
        def write_diff( strings, plurals, path )
          path ||= "#{Vocab.root}/#{DIFF}"
          write( strings, path )
        end

        def write_full( strings, plurals, path )
          path ||= "#{Vocab.root}/#{FULL}"
          write( strings, path )
        end

        def write( translations, path, locale = :en )
          data = hasherize( translations, locale ).to_yaml
          File.open( path, "w+" ) { |f| f.write( data ) }
          Vocab.ui.say( "Extracted to #{path}" )
        end

        def previous_strings( locales_root = nil )
          locales_root ||= "config/locales"
          tmpdir = "#{Vocab.root}/tmp/last_translation"
          `rm -rf #{tmpdir}/*`

          sha = Vocab.settings.last_translation
          translation_files = `git ls-tree --name-only -r #{sha}:#{locales_root}`.split( "\n" )
          translation_files = translation_files.select { |f| f =~ /en.(yml|rb)$/ }
          translation_files.each do |path|
            tmpdir_path = "#{tmpdir}/#{path}"
            FileUtils.mkdir_p( File.dirname( tmpdir_path ) )
            File.open( tmpdir_path, "w+" ) do |f|
              yml = previous_file( "#{locales_root}/#{path}", sha )
              f.write( yml )
            end
          end

          return translations( tmpdir )
        end

        def current_strings( locales_root = nil )
          locales_root ||= "#{Vocab.root}/config/locales"
          return translations( locales_root )
        end

        # Treat this as a no-op because plurals handled like normal strings
        def previous_plurals
          return {}
        end

        # Treat this as a no-op because plurals handled like normal strings
        def current_plurals
          return {}
        end

        def extract_all( locales_root = nil, result_dir = nil )
          locales_root ||= "#{Vocab.root}/config/locales"
          result_dir ||= "#{Vocab.root}"
          
          translator = Vocab::Translator::Rails.new
          translator.load_dir( locales_root )

          for locale in translator.available_locales do
            strings = translations( locales_root, locale )
            path = "#{result_dir}/#{locale}.full.yml"
            write( strings, path, locale )
          end
        end

        def translations( dir, locale = :en )
          translator = Vocab::Translator::Rails.new( locale )
          translator.load_dir( dir )
          return translator.flattened_translations( :prefix => true )
        end

        def hasherize( diff, locale = :en )
          translator = Vocab::Translator::Rails.new( locale )
          diff.each do |key, value|
            key = key.to_s.gsub!( /^#{locale.to_s}\./, '' )
            translator.store( key, value )
          end
          return translator.translations( :prefix => true )
        end

        def examples
          return [ "#{Vocab.root}/tmp/translations" ]
        end

        def print_instructions( values = {} )
          values[ :diff ] = DIFF
          values[ :full ] = FULL
          values[ :tree ] = <<-EOS
tmp/translations/es.yml
tmp/translations/zh.yml
          EOS

          super( values )
        end
      end
    end
  end
end