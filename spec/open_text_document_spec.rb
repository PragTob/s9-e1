require 'odfdom'

TESTFILES_DIRECTORY = "spec/test_files/"

def file_exists?(file_name)
  File.exist?(TESTFILES_DIRECTORY + file_name)
end

describe "ODFDOM::OpenTextDocument" do

  before :each do
    @doc = ODFDOM::OpenTextDocument.new
  end

  after :each do
    Dir.chdir(TESTFILES_DIRECTORY) do
      Dir.glob("*.*").each do |file|
        File.delete file
      end
    end
  end

  it "should be able to create a new text document" do
    @doc.should_not == nil
  end

  it "should create a file when saved" do
    @doc.save(TESTFILES_DIRECTORY+"test.odt")

    file_exists?("test.odt").should == true
  end

  it "should create a file when create is used" do
    ODFDOM::OpenTextDocument.new(TESTFILES_DIRECTORY+"another_test.odt") {}

    file_exists?("another_test.odt").should == true
  end

  it "should automatically add .odt when it is not specified" do
    @doc.save(TESTFILES_DIRECTORY + "no_extension")

    file_exists?("no_extension").should_not == true
    file_exists?("no_extension.odt").should == true
  end

  it "should be empty when created" do
    @doc.size.should == 0
  end

  it "should have increased size when a pragraph is added" do
    @doc << "A nice paragraph"
    @doc.size.should == 1
  end

  it "should not change its size when loaded" do
    @doc << "A little paragraph" << "and another one"
    old_size = @doc.size
    @doc.save(TESTFILES_DIRECTORY + "test.odt")

    the_same_doc = ODFDOM::OpenTextDocument.new(TESTFILES_DIRECTORY + "test.odt")
    the_same_doc.size.should == old_size
  end

  it "should not change it's size when add_text is called,
      since no new paragraphs are created" do
    @doc << "A paragraph"
    old_size = @doc.size
    @doc.add_text "Blablabla"
    @doc.size.should == old_size
  end

  it "should be able to add a styled paragraph" do
    lambda { @doc.add_paragraph("Para", :bold) }.should_not raise_error
    @doc.size.should == 1
  end

  it "should be able to add an heading" do
    lambda { @doc.add_heading("Heading") }.should_not raise_error
    @doc.size.should == 1
  end

  it "should be able to iterate over all elements using each" do
    same = "same"
    @doc << same << same << same
    i = 0
    @doc.each do |each|
      i += 1
      each.to_s.should == same
    end

    i.should == 3
  end

  it "should be able to use the to_a method thanks to Enumerable" do
    @doc << "1" << "2" << "3"
    @doc.add_heading("I am also a normal item!")

    @doc.to_a.size.should == @doc.size
  end

  # last check of Enumerable integration working, I promise!
  it "should be able to use the awesome select method thanks to Enumerable" do
    @doc << "The good" << "The bad" << "The ugly"
    ugly = @doc.select { |each| each.content =~ /ugly/ }

    ugly.size.should == 1
    ugly.first.content.should == "The ugly"
  end

  # just to make sure no errors occure with normal code
  # I lack the traversing capabilities for some real good tests
  it "should not raise an error when it does normal work" do
    lambda do
      ODFDOM::OpenTextDocument.new(TESTFILES_DIRECTORY + "/styles") do
        add_heading "I am sooo big!"
        add_paragraph("I am feeling bold today", :bold)
        add_paragraph("I am italic", :italic)

        new_style("special heading", :paragraph) do
          font_size "24pt"
          font_weight "bold"
          font_style "italic"
          display_name "Bold Italic Headline"
        end

        add_paragraph("Look at me, I am so beautiful!", "special heading")
      end
    end.should_not raise_error

  end

end

