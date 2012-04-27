# Code originally written by Jonathan Thomas @JayTeeSr

require "spec_helper"

describe "Vocab::Mock::Rails" do

  context "with backend" do

    let( :generator ) { Vocab::Mock::Rails.new(:backend => :bogusbackend) }

    describe "#generate" do
      it "should raise an exception when xx-file already exists" do
        File.should_receive(:exists?).with(generator.send(:locale_file)).and_return(true)
        expect { generator.generate }.to raise_error(RuntimeError)
      end
    end

    # FIXME: don't test private methods -- move translation to a module, once this is in the vocab gem
    describe "#to_xx" do
      let(:key) { :key }
      let(:simple_string) {"hello world"}
      let(:translated_simple_string) {"xxxxx xxxxx"}
      it "should handle simple strings" do
        generator.send(:to_xx, key, simple_string).should == translated_simple_string
      end

      let(:string_with_percentage) { "100% SAFE, and FREE!" }
      let(:translated_string_with_percentage) {"100% xxxxx xxx xxxxx"}
      it "should handle strings with percentage(s)" do
        generator.send(:to_xx, key, string_with_percentage).should == translated_string_with_percentage
      end

      let(:string_with_punctuation) {"hello, world!"}
      let(:translated_string_with_punctuation) {"xxxxxx xxxxxx"}
      it "should handle string(s) with punctuation" do
        generator.send(:to_xx, key, string_with_punctuation).should == translated_string_with_punctuation
      end

      let(:string_with_leading_substitution) {"%{name}'s Toybox"}
      let(:translated_string_with_leading_substitution) {"%{name}xx xxxxxx"}
      it "should handle string(s) with leading substitution" do
        generator.send(:to_xx, key, string_with_leading_substitution).should == translated_string_with_leading_substitution
      end

      let(:complex_string) { "People in your family can now use Zoodles to stay in touch with %{kids}.  Invite grandparents, aunts and uncles, with %{kids} so they can see %{children};  I'd really join %{bigkids}'s Zoodles!" }
      let(:translated_complex_string) { "xxxxxx xx xxxx xxxxxx xxx xxx xxx xxxxxxx xx xxxx xx xxxxx xxxx %{kids}x  xxxxxx xxxxxxxxxxxxx xxxxx xxx xxxxxxx xxxx %{kids} xx xxxx xxx xxx %{children}x  xxx xxxxxx xxxx %{bigkids}xx xxxxxxxx" }
      it "should handle complex string(s)" do
        generator.send(:to_xx, key, complex_string).should == translated_complex_string
      end

      let(:html_string) { "Click &quot;Install Now&quot;  to begin\" \"Choose <strong>Control Panel</strong> under the <strong>Start</strong> menu. Displaying %{model} <b>%{from}&nbsp;-&nbsp;%{to}</b> Segment single-syllable words into their components (e g , cat = /c/a/t/; splat = /s/p/l/a/t/; rich = /r/i/ch/ ) "}
      let(:translated_html_string) { "xxxxx &quot;xxxxxxx xxx&quot;  xx xxxxxx xxxxxxx <strong>xxxxxxx xxxxx</strong> xxxxx xxx <strong>xxxxx</strong> xxxxx xxxxxxxxxx %{model} <b>%{from}&nbsp;x&nbsp;%{to}</b> xxxxxxx xxxxxxxxxxxxxxx xxxxx xxxx xxxxx xxxxxxxxxx xx x x xxx x xxxxxxxx xxxxx x xxxxxxxxxxxx xxxx x xxxxxxxx x "}
      it "should handle html string(s)" do
        generator.send(:to_xx, key, html_string).should == translated_html_string
      end

    end

  end

end