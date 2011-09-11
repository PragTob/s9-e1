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
    OpenTextDocument.create(TESTFILES_DIRECTORY+"/another_test.odt") do
    end

    file_exists?("another_test.odt").should == true
  end

  it "should automatically add .odt when it is not specified" do
    @doc.save(TESTFILES_DIRECTORY + "/no_extension")

    file_exists?("no_extension").should_not == true
    file_exists?("no_extension.odt").should == true
  end

end

