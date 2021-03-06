require "bundler"
Bundler.setup

require "rspec"
require "vocab"
require "support/matchers"
require "support/shared"

require 'simplecov'

SimpleCov.start do
    coverage_dir 'coverage'
    add_filter "/spec/"
  end

Vocab.ui.silent = true

RSpec.configure do |config|
  config.include Vocab::Spec::Matchers
end

def vocab_root
  return File.expand_path( '../..', __FILE__ )
end


