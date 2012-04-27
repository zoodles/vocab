module Vocab
  module Spec
    module Matchers
      #def be_awesome
      #  RSpec::Matchers::Matcher.new :be_awesome do
      #    match do |actual|
      #      actual.should == "awesome"
      #    end
      #  end
      #end
    end
  end
end

# Matcher to compare an in-memory string with a ground truth file.
# Exports the actual value as a .tmp file as a side effect.

RSpec::Matchers.define :eql_file do |expected|

  description do
    "match the contents of #{expected}"
  end
  
  match do |actual|
    File.open( "#{vocab_root}/#{expected}.tmp","w+b" ) { |io| io.write actual }
    slurped = File.open( "#{vocab_root}/#{expected}","rb" ) {|io| io.read }
    actual == slurped
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would match the contents of #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not match the contents of #{expected}"
  end
  
end