require 'odfdom'


describe "OpenParagraph" do

  before :each do
    doc = OpenTextDocument.new
    doc << "A stupid paragraph"
    doc.add_paragraph("A styled paragraph", :bold)
    paragraphs = doc.to_a

    @paragraph = paragraphs[0]
    @styled_paragraph = paragraphs[1]
  end

  it "should display it's content when to_s is called" do
    @paragraph.to_s.should == "A stupid paragraph"
    @styled_paragraph.to_s.should == "A styled paragraph"
  end

  it "should be able to retrieve the style name" do
    @styled_paragraph.style.should == "bold"
  end

end

