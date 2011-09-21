require 'odfdom'

describe "OpenStyle" do

  # styles belong to docs therefore we need a doc
  before :each do
    @doc = ODFDOM::OpenTextDocument.new
    @style = @doc.style("testie", :paragraph)
  end

  # added to protect against regressions
  it "should be able to create styles in a block" do
    style = @doc.style("test", :paragraph) do
      display_name "A good test"
    end

    style.display_name.should == "A good test"
  end

  it "should also be able to use the dual purpose accessor with name" do
    style = @doc.style("test", :paragraph) do
      name "A little test"
    end

    style.name.should == "A little test"
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

