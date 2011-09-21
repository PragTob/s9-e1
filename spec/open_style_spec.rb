require 'odfdom'

describe "OpenStyle" do

  # styles belong to docs therefore we need a doc
  before :each do
    @doc = ODFDOM::OpenTextDocument.new
    @style = @doc.new_style("testie", :paragraph)
  end

  # added toprotect against regressions
  it "should be able to create styles in a block" do
    style = @doc.new_style("test", :paragraph) do
      display_name "A good test"
    end

    style.display_name.should == "A good test"
  end
  describe "some attributes may be set with a symbol" do

    it "should work for font_weight" do
      @style.font_weight = :bold
      @style.font_weight.should == "bold"
    end

    it "should work for font_style" do
      @style.font_weight = :italic
      @style.font_weight.should == "italic"
    end

  end

end

