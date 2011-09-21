require 'odfdom'

describe "OpenOfficeStyles" do

  before(:each) do
    @doc = ODFDOM::OpenTextDocument.new
  end

  it "should have one more style for a family when we add a style" do
    styles = @doc.document_styles
    old_number = styles.styles_for_family(:paragraph).size

    lambda do
      styles.new_style("test", :paragraph)
    end.should change { styles.styles_for_family(:paragraph).size }.by(1)

  end

end

