$LOAD_PATH.push './lib'

require 'odfdom'

def delete_files_in_the_beginning
  File.delete "nonexisting.odt" if File.exist? "nonexisting.odt"
  File.delete "no_odt_needed.odt" if File.exist? "no_odt_needed.odt"
end

delete_files_in_the_beginning

my_document = OpenTextDocument.new
my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
my_document.add_paragraph "olololol"
my_document.add_paragraph("I am feeling bold today", :bold)
my_document.save "Tobi.odt"
my_document.close

OpenTextDocument.new "Tobi.odt" do
  add_paragraph "blablabla"
end

OpenTextDocument.create "nonexisting.odt" do
  self << "I don't exist!" << "but you just created me!" << "That's awesome!"
end

OpenTextDocument.create "no_odt_needed" do
  add_paragraph "Huhu"
end

