require 'i18n'
require 'fileutils'

module Vocab
  class Extractor
    class << self
      def extract
        current = extract_current
        previous = extract_previous
        need_translations = diff( previous, current )
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

      # TODO move to rails only subclass
      def extract_previous
        tmpdir = "#{Vocab.root}/tmp/last_translation"
        Dir.rm_rf( "#{tempdir}/*" )

        sha = Settings.last_translation
        translation_files = `git ls-tree --name-only -r #{sha}:config/locales`.split( "\n" )
        translation_files.select! { |f| f =~ /en.(yml|rb)$/ }
        translation_files.each do |path|
          File.open( "#{tempdir}/#{path}" ) do |f|
            yml = `git-show #{sha}:#{path}`
            f.write( yml )
          end
        end

        return translations( Dir.glob( "#{tmpdir}/**/*.{yml,rb}" ) )
      end

      # TODO move to rails only subclass
      def extract_current
        return translations( Dir.glob( "#{Vocab.root}/config/locales/**/*.{yml,rb}" ) )
      end

      # TODO move to rails only subclass
      def translations( filenames )
        # TODO get rid of this hack.  Subclass Simple?  Move to Vocab::Application?
        I18n::Backend::Simple.send( :include, I18n::Backend::Flatten )

        I18n.load_path += filenames
        backend = I18n::Backend::Simple.new
        backend.send( :init_translations )
        data = backend.send( :translations )
        translations = backend.flatten_translations( :en, data, true, true )
        return translations
      end
    end
  end
end