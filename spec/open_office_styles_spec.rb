require 'odfdom'

describe "OpenOfficeStyles" do

  before(:each) do
    @doc = OpenTextDocument.new
  end

  it "should have one more style for a family when we add a style" do
    styles = @doc.document_styles
    old_number = styles.styles_for_family(:paragraph).size

    styles.new_style("test", :paragraph)

    styles.styles_for_family(:paragraph).size.should == (old_number + 1)
  end

end

