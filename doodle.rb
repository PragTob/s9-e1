# this is a doodling file where I try out stuff and save important code snippets
# examples on how to use this:

require 'java'
require 'bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument
out = OdfTextDocument.newText
out = OdfTextDocument.newTextDocument
out.addText "I am awesome!"
out.newParagraph
out.new_paragraph "Your turn to be awesome!"
out.save "quick_try.odt" # returns nil - not cool!

