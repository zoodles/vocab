# Code originally written by Jonathan Thomas @JayTeeSr

module Vocab
  module Mock
    class Rails < Base
      DEFAULT_FROM_LOCALE = :en
      TO_LOCALE = :xx

      def self.generate(options={})
        new(options).generate
      end

      attr_reader :to_locale, :from_locale, :backend
      def initialize(options={})
        @to_locale = options[:to_locale] || TO_LOCALE
        @from_locale = options[:from_locale] || DEFAULT_FROM_LOCALE
        @backend = options[:backend] || I18n.backend
      end

      def generate
        clear
        translate
        persist
      end

      private

      ## CLEAR METHOD(S)
      def clear
        if File.exists?(locale_file)
          raise RuntimeError, "You must remove locale file #{locale_file.inspect}, reload Rails, then try again."
        end
      end

      ## PERSIST METHOD(S)
      def persist
        if backend.respond_to?(:write_file)
          backend.write_file(locale_file)
        else
          yaml = { to_locale.to_s => stored_translation }.to_yaml
          File.open( locale_file, 'w' ) { |f| f.write( yaml ) }
        end
      end

      def stored_translation
        if backend.respond_to?(:translation)
          backend.translation
        else
          backend.send(:translations)[to_locale]
        end
      end

      def locale_file
        @locale_file ||= "#{Vocab.root}/config/locales/#{to_locale}.yml"
      end

      ## TRANSLATE METHOD(S)
      def translate
        flat_backend.each do |key, original_value|
          value = to_xx(key, original_value)
          store(key, value)
        end
      end

      def flat_backend
        @flat_backend ||=
          begin
            if backend.respond_to?(:flattened_translations)
              backend.flattened_translations
            else
              I18n::Backend::Simple.send( :include, I18n::Backend::Flatten )
              backend.load_translations
              backend.flatten_translations(from_locale, backend.send(:translations)[from_locale], true, false)
            end
        end
      end

      def store(key, value)
        if backend.respond_to?(:store)
          backend.store(key, value)
        else
          keys = I18n.normalize_keys( from_locale, key, [], nil)
          keys.shift # remove locale
          data = keys.reverse.inject( value ) { |result, _key| { _key => result } }
          @backend.store_translations( to_locale, data )
        end
      end

      def to_xx(key, original_value)
        return original_value.map {|v| to_xx(key, v) } if original_value.respond_to?(:map)
        return original_value unless original_value && original_value.is_a?(String)
        return recursively_replace_with_exes(original_value)
      end

      def recursively_replace_with_exes(original_value)
        return "" if original_value.nil? || original_value.empty?
        regex1 = %r/(?<not-html-substitution-or-format>((?<=^|[>}])|(?<=%)\s)([^}><%{]+?)(?=[%<]|$))/
        regex2 = %r/(?<code>(&#?(?:[\dA-Za-z]+?);))/

        if matches = original_value.match(regex1)
          if also_matches = matches[1].match(regex2)
            return (also_matches.pre_match.sub(regex1, replace_with_exes(also_matches.pre_match)) ) +
              matches.pre_match + (also_matches[1] || "") +
              (recursively_replace_with_exes(also_matches.post_match)|| "") +
              (recursively_replace_with_exes(matches.post_match)|| "")
          else
            return matches.pre_match + replace_with_exes(matches[1]) +
              (recursively_replace_with_exes(matches.post_match)|| "")
          end
        else
          return original_value
        end
      end

      def replace_with_exes(str)
        return "" unless str
        str.gsub(/[^[:blank:][:digit:]]/,"x")
      end
    end
  end
end