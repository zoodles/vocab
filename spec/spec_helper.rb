require "bundler"
Bundler.setup

require "rspec"
require "vocab"
require "support/matchers"

Vocab.ui.silent = true

RSpec.configure do |config|
  config.include Vocab::Spec::Matchers
end

def vocab_root
  return File.expand_path( '../..', __FILE__ )
end

def should_eql_file( actual, path )
  @tmp = File.open( "#{vocab_root}/#{path}.tmp","wb") { |io| io.write actual }
  @expected = File.open("#{vocab_root}/#{path}","rb") {|io| io.read }
  actual.chomp.strip.should eql( @expected.chomp.strip )
end