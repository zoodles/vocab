require "bundler"
Bundler.setup

require "rspec"
require "newgem"
require "support/matchers"

Rspec.configure do |config|
  config.include Vocab::Spec::Matchers
end