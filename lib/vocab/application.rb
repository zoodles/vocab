module Vocab
  class Application

    def self.run
      handle_command
    end

    def self.handle_command
      case ARGV.first
      when "export"
        puts "this is export"
      when "import"
        puts "this is import"
      end

      puts "Vocab.settings.update_translation = #{Vocab.settings.update_translation}"
    end

  end
end