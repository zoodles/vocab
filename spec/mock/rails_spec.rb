# Code originally written by Jonathan Thomas (@JayTeeSr)

require "spec_helper"

describe "Vocab::Mock::Rails" do

  context "with backend" do

    before( :each ) do
      @local_dir = "#{vocab_root}/spec/data/rails/locales"
      @output_file = "#{vocab_root}/spec/tmp/mock/xx.yml"
    end

    let( :generator ) { Vocab::Mock::Rails.new( :locale_dir => @local_dir,
                                                :output_file => @output_file ) }

    describe "#generate" do
      it "should not raise an exception when xx-file already exists" do
        File.should_receive( :delete ).with( @output_file )
        generator.generate
      end

      it "should output xx.yml file with all values replaced with 'x'" do
        generator.generate
        actual = File.open( generator.output_file ) { |f| f.read }
        actual.should eql_file( "spec/data/rails/locales/xx.yml" )
      end
    end

    describe "flat_backend" do

      it "returns a flattened hash of translations" do
        hash = generator.send( :flat_backend )
        hash.should == {:"marketing.banner"=>"This product is so good",
                        :"dashboard.chart"=>"This value has changed",
                        :"dashboard.details"=>"This key/value has been added",
                        :"menu.first"=>"First menu item",
                        :"menu.second"=>"Second menu item",
                        :not_in_es=>"This key not in spanish",
                        :"users.one"=>"1 user",
                        :"users.other"=>"%{count} users",
                        :"models.product.id_125.description"=>"Green with megawatts",
                        :"models.product.id_125.name"=>"Lazer",
                        :"models.product.id_36.description"=>"Polarized and lazer resistant",
                        :"models.product.id_36.name"=>"This nested value has changed",
                        :"models.product.id_55.description"=>"A new nested description",
                        :"models.product.id_55.name"=>"a new nested name"}
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