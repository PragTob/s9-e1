describe "OpenStyle" do

  # styles belong to docs therefore we need a doc
  before :each do
    @doc = OpenTextDocument.new
  end

  # added toprotect against regressions
  it "should be able to create styles in a block" do
    style = @doc.new_style("test", :paragraph) do
      display_name "A good test"
    end

    style.display_name.should == "A good test"
  end

end

