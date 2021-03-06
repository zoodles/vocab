module Vocab
  module Merger
    class Rails < Base
      INTERPOLATION_PATTERN = /%{(.*?)}/

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'config/locales'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge_file( locales_path, strict = false )
        return unless translatable?( locales_path )
        create_if_missing( locales_path )

        # list of keys that need to be in the translated file
        keys = Vocab::Merger::Rails.keys_for_file( locales_path )
        english = Vocab::Merger::Rails.load_english( locales_path )

        # existing translations already in the file
        locales_translator = translator( locales_path )
        locales = locales_translator.flattened_translations

        # new translations from the translators
        update_path = "#{@updates_dir}/#{locales_translator.locale}.yml"
        unless File.exists?( update_path )
          Vocab.ui.say( "Missing update file: #{update_path} to translate #{locales_path}" )
          return
        end
        updates_translator = translator( update_path )
        updates = updates_translator.flattened_translations


        # apply updated keys to locales hash
        keys.each do |key|
          next if Vocab::Translator::Base.ignore_key?( key )

          value = updates[ key ] || locales[ key ]
          if value
            locales_translator.store( key, value )
            check_matching_interpolations( key, english[ key ], value, locales_path, strict )
          else
            Vocab.ui.warn( "No translation found for key #{key} while merging #{locales_path}" )
          end
        end

        locales_translator.write_file( locales_path )
      end

      def check_matching_interpolations( key, old_value, new_value, locales_path, strict = false )
        old_interpolations = old_value.to_s.scan( INTERPOLATION_PATTERN )
        new_interpolations = new_value.to_s.scan( INTERPOLATION_PATTERN )
        unless strict
          old_interpolations.sort!
          new_interpolations.sort!
        end

        if old_interpolations != new_interpolations
          Vocab.ui.warn( "Interpolation mismatch for key #{key} in #{locales_path}. \n English: #{old_value} Translation: #{new_value}" )
        end
      end

      def check_all_interpolations( file, strict = false )
        # list of keys that need to be in the translated file
        keys = Vocab::Merger::Rails.keys_for_file( file )
        english = Vocab::Merger::Rails.load_english( file )

        # existing translations already in the file
        locales_translator = translator( file )
        locales = locales_translator.flattened_translations

        keys.each do |key|
          next if Vocab::Translator::Base.ignore_key?( key )

          value = locales[ key ]
          if value
            check_matching_interpolations( key, english[ key ], value, file, strict )
          end
        end
        return nil
      end

      def self.keys_for_file( path )
        en_path = Vocab::Translator::Rails.en_equivalent_path( path )
        translator = Vocab::Translator::Rails.new
        translator.load_file( en_path )
        return translator.flattened_translations.keys
      end

      def self.load_english( path )
        en_path = Vocab::Translator::Rails.en_equivalent_path( path )
        translator = Vocab::Translator::Rails.new
        translator.load_file( en_path )
        return translator.flattened_translations
      end

      def translatable?( path )
        if File.basename( path ) == 'en.yml'
          Vocab.ui.warn( "can't translate english file #{path}" )
          return false
        end

        unless File.exists?( Vocab::Translator::Rails.en_equivalent_path( path ) )
          Vocab.ui.warn( "skipping because no english equivalent for #{path}" )
          return false
        end

        if( File.exists?( path ) )
          extension = File.basename( path, '.yml' )
          contents = YAML.load_file( path ).keys.first.to_s
          if( extension != contents )
            Vocab.ui.warn( "File extension does not match file contents in #{path}" )
            return false
          end
        end

        return true
      end

      def translator( path )
        translator = Vocab::Translator::Rails.new
        translator.load_file( path ) if File.exists?( path )
        return translator
      end

      def create_if_missing( path )
        return if File.exists?( path )
        locale = File.basename( path, '.yml' )
        Vocab.ui.say( "Creating file #{path}" )
        File.open( path, 'w+' ) { |file| file.write( { locale => {} }.to_yaml ) }
      end

      # TODO cache this so you don't hit the FS so much
      def translation_locales
        return Dir.glob( "#{@updates_dir}/*.yml" ).collect { |f| File.basename( f, '.yml' ) }
      end

      def files_to_merge
        paths = []
        Dir.glob( "#{@locales_dir}/**/en.yml" ).each do |en_path|
          translation_locales.each do |locale|
            paths << en_path.gsub( /en.yml$/, "#{locale}.yml" )
          end
        end
        return paths
      end

    end
  end
end