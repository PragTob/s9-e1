require 'lib/odfdom.rb'

my_document = OpenTextDocument.new
my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
my_document.save "Tobi.odt"

