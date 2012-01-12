require 'fileutils'
require 'i18n'
require 'pathname'

require 'vocab/application'
require 'vocab/extractor'
#require 'vocab/translator'
require 'vocab/merger'
require 'vocab/settings'
require 'vocab/ui'
require 'vocab/version'

I18n::Backend::Simple.include( I18n::Backend::Flatten )

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
