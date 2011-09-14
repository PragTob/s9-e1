$LOAD_PATH.push './lib'

require 'odfdom'

TESTFILES_DIRECTORY = "spec/test_files"

def file_exists?(file_name)
  File.exist?(TESTFILES_DIRECTORY + "/" + file_name)
end

describe "OpenTextDocument" do

  before :each do
    @doc = OpenTextDocument.new
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
    @doc.save(TESTFILES_DIRECTORY+"/test.odt")

    file_exists?("test.odt").should == true
  end

  it "should create a file when create is used" do
    OpenTextDocument.new(TESTFILES_DIRECTORY+"/another_test.odt") {}

    file_exists?("another_test.odt").should == true
  end

  it "should automatically add .odt when it is not specified" do
    @doc.save(TESTFILES_DIRECTORY + "/no_extension")

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
    @doc.save(TESTFILES_DIRECTORY + "/test.odt")

    the_same_doc = OpenTextDocument.new(TESTFILES_DIRECTORY + "/test.odt")
    the_same_doc.size.should == old_size
  end

  it "should not change it's size when add_text is called,
      since no new paragraphs are created" do
    @doc << "A paragraph"
    old_size = @doc.size
    @doc.add_text "Blablabla"
    @doc.size.should == old_size
  end

  # just to make sure no errors occure with normal code
  # I lack the traversing capabilities for some real good tests
  it "should not raise an error when it does normal work" do
    lambda do
      OpenTextDocument.new(TESTFILES_DIRECTORY + "/styles") do
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

