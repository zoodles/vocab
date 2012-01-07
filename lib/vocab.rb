require 'vocab/application'
require 'vocab/settings'
require 'vocab/version'

require 'fileutils'
require 'pathname'

module Vocab

  class << self
    def settings
      @settings ||= Settings.new( root )
    end

    # Returns root directory where .vocab is located
    # TODO: make this work when not executing command where .vocab is
    def root
      current = File.expand_path( Dir.pwd )
      filename = File.join( current, '.vocab' )
      raise "Error: .vocab not in current directory" unless File.file?( filename )
      return current
    end

  end

end
