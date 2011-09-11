$LOAD_PATH.push './lib'

require 'odfdom'

my_document = OpenTextDocument.new
my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
my_document.save "Tobi.odt"

