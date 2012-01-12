require 'fileutils'
require 'pathname'

require 'vocab/application'
require 'vocab/extractor_base'
require 'vocab/rails_extractor'
require 'vocab/settings'
require 'vocab/ui'
require 'vocab/version'

module Vocab

  class << self
    def settings
      @settings ||= Settings.new( root )
    end

    def ui
      @ui ||= UI.new
    end

    # Returns root directory where .vocab is located
    # TODO: make this work when not executing command where .vocab is
    def root
      return File.expand_path( Dir.pwd )
    end

  end

end
