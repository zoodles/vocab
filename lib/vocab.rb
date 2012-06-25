require 'fileutils'
require 'i18n'
require 'pathname'
require 'nokogiri'
require 'htmlentities'
require 'yaml'
require 'ya2yaml'


require 'vocab/application'
require 'vocab/extractor'
require 'vocab/translator'
require 'vocab/cleaner'
require 'vocab/merger'
require 'vocab/settings'
require 'vocab/ui'
require 'vocab/validator'
require 'vocab/version'

I18n::Backend::Simple.send( :include, I18n::Backend::Flatten )

module Vocab

  class << self
    def settings
      @settings ||= Settings.new( root )
    end

    def ui
      @ui ||= UI.new
    end

    # Returns root directory where .vocab is located
    # TODO: make this work in subdirectory under .vocab
    def root
      return File.expand_path( Dir.pwd )
    end

  end

end
