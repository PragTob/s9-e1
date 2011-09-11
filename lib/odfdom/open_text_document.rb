require 'java'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument

class OpenTextDocument

  def initialize
    @document = OdfTextDocument.newTextDocument
    # documents start out with an empty paragraph, I don't want that
    clear_document
  end

  # this removes ALL nodes in the document
  def clear_document
    content_root = @document.content_root
    node = content_root.first_child

    while node != nil
      content_root.remove_child node
      node = content_root.first_child
    end
  end

  def save(file_path)
    @document.save file_path # returns nil on success :-<
  end

  # Create a new paragraph with the given text.
  # If no text is given, just create a paragraph
  def add_paragraph(paragraph=nil)
    if paragraph
      @document.new_paragraph paragraph
    else
      @document.new_paragraph
    end
    self
  end

  def <<(paragraph)
    add_paragraph paragraph
  end

  # Text is just added to the last paragraph, no new paragraph created
  def add_text(text)
    @document.add_text text
  end

end

