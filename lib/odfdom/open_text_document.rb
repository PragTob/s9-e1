require 'java'
require 'odfdom/open_document'
require 'odfdom/open_office_styles'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument

class OpenTextDocument < OpenDocument

  FILE_ENDING = ".odt"

  # massively overloaded, may be used to create a new document
  # or to load an existing one, if a path is given
  def initialize(file_path=nil, &block)
    unless file_path
      #create a new document
      @document = OdfTextDocument.newTextDocument
      # documents start out with an empty paragraph, I don't want that
      clear_document
    else
      @document = OdfTextDocument.loadDocument file_path
    end

    if block_given?
      begin
        instance_eval(&block)
        save(file_path) if file_path
      ensure
        close
      end
    end

  end

  def self.create(file_path, &block)
    raise "This method expects a block" unless block_given?

    doc = self.new
    begin
      doc.instance_eval(&block)
      doc.save file_path
    ensure
      doc.close
    end
  end

  # Save the document to the given path
  # you don't even have to supply the .odt every time
  def save(file_path)
    file_path << FILE_ENDING if file_path[-4..-1] != FILE_ENDING
    @document.save file_path

    # it normally returns nil, but some people like to use save in if-statements
    self
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
    self
  end

  def document_styles
    OpenOfficeStyles.new(@document.get_or_create_office_styles)
  end

end

