$LOAD_PATH.push './lib'

require 'odfdom'

def delete_files_in_the_beginning
  Dir.glob("*.odt").each { |each| File.delete each }
end

delete_files_in_the_beginning

# simply creating and saving a file
my_document = ODFDOM::OpenTextDocument.new
my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
my_document.save "Tobi.odt"
my_document.close

# you may also add to already existing documents!
# if a file name is specified, files get saved automatically
# also the file gets saved automatically
ODFDOM::OpenTextDocument.new "Tobi.odt" do
  paragraph "Yeah it really is a nice day!"
end

# You can also create documents
# you don't need to supply a file ending, this nice gem adds it for you!
ODFDOM::OpenTextDocument.new "nonexisting" do
  paragraph "I don't exist!"
  paragraph "but you just created me!"
  paragraph "That's awesome!"
end

# And you may also use some of the default styles
ODFDOM::OpenTextDocument.new "styles" do
  heading "I am sooo big!"
  paragraph("I am feeling bold today", :bold)
  paragraph("I am italic", :italic)

  # or define a new style
  style("special heading", :paragraph) do
    font_size "24pt"
    font_weight "bold"
    font_style "italic"
    display_name "Bold Italic Headline"
  end

  # refer to the style by name
  paragraph("Look at me, I am so beautiful!", "special heading")

  each { |each| puts each }
end

