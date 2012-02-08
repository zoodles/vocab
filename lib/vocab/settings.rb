module Vocab
  class Settings
    def initialize( root )
      @root   = root
      @local_config = File.exist?( config_file ) ? YAML.load_file( config_file ) : {}
    end

    def config_file
      Pathname.new( "#{@root}/.vocab" )
    end

    def last_translation
      return @local_config[ 'last_translation' ]
    end

    def update_translation
      current_sha = `git rev-parse HEAD`.strip
      @local_config[ 'last_translation' ] = current_sha
      write_settings
      return current_sha
    end

    def write_settings
      File.open( config_file, 'w' ) { |f| f.write( @local_config.to_yaml ) }
      `git add #{config_file}`
    end

    def self.create
      Vocab.ui.say( "Writing new .vocab file" )
      Vocab.ui.say( "Be sure to check the .vocab file into your repo" )
      settings = Vocab::Settings.new( Dir.pwd )
      settings.update_translation
      settings.write_settings
    end
  end
end