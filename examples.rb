$LOAD_PATH.push './lib'

require 'odfdom'

def delete_files_in_the_beginning
  Dir.glob("*.odt").each { |each| File.delete each }
end

delete_files_in_the_beginning

# simply creating and saving a file
my_document = OpenTextDocument.new
my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
my_document.save "Tobi.odt"
my_document.close

# you may also add to already existing documents!
# if a file name is specified, files get saved automatically
# also the file gets saved automatically
OpenTextDocument.new "Tobi.odt" do
  add_paragraph "Yeah it really is a nice day!"
end

# You can also create documents
# you don't need to supply a file ending, this nice gem adds it for you!
OpenTextDocument.create "nonexisting" do
  self << "I don't exist!" << "but you just created me!" << "That's awesome!"
end

# And you may also use some of the default styles
OpenTextDocument.create "styles" do
  add_heading "I am sooo big!"
  add_paragraph("I am feeling bold today", :bold)
  add_paragraph("I am italic", :italic)

  # or define a new style
  new_style("special heading", :paragraph) do
    font_size "24pt"
    font_weight "bold"
    font_style "italic"
    display_name "Bold Italic Headline"
  end

  # refer to the style by name
  add_paragraph("Look at me, I am so beautiful!", "special heading")
end

