require 'i18n'
require 'fileutils'

module Vocab
  class Extractor
    class << self
      def extract
        current = extract_current
        previous = extract_previous
        diff( previous, current )
      end

      # make a hash of all the translations that are new or changed in the current yml
      def diff( previous, current )
        diff = {}
        current.each do |key, value|
          previous_value = previous[ key ]
          if( previous_value.nil? || previous_value != value )
            diff[ key ] = value
          end
        end
        return diff
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

        return translations( Dir.glob( "#{tmpdir}/**/*.{yml,rb}" ) )
      end

      def extract_current( locales_root = nil )
        locales_root ||= "#{Vocab.root}/config/locales"
        return translations( Dir.glob( "#{locales_root}/**/*.{yml,rb}" ) )
      end

      def translations( filenames )
        # TODO get rid of this hack.  Subclass Simple?  Move to Vocab::Application?
        I18n::Backend::Simple.send( :include, I18n::Backend::Flatten )

        I18n.load_path = filenames
        backend = I18n::Backend::Simple.new
        backend.reload!
        backend.send( :init_translations )
        data = backend.send( :translations )
        translations = backend.flatten_translations( :en, data, true, false )
        return translations
      end
    end
  end
end