require 'java'
require_relative 'open_document'
require_relative 'open_office_styles'
require_relative '../../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument
java_import org.odftoolkit.odfdom.incubator.doc.text.OdfTextParagraph
java_import org.odftoolkit.odfdom.dom.OdfContentDom

# A normal open text document where you can add paragraphs etc.
class OpenTextDocument < OpenDocument
  include Enumerable

  FILE_ENDING = ".odt"
  DEFAULT_STYLES = { bold: "bold", italic: "italic", heading: "heading" }
  DEFAULT_FONT_SIZE = "12pt"

  # massively overloaded, may be used to create a new document
  # or to load an existing one, if a path is given
  def initialize(file_path=nil, &block)
    unless file_path
      #create a new document
      @document = OdfTextDocument.newTextDocument
      # documents start out with an empty paragraph, we don't want that
      clear_document
    else
      @document = OdfTextDocument.loadDocument file_path
    end

    create_default_styles

    if block_given?
      begin
        instance_eval(&block)
        # automatically save the file if a file_path is given
        save(file_path) if file_path
      ensure
        close
      end
    end

  end

  def set_important_instance_variables
    # most of the Java methods need these two for their functionality
    @content_dom = @document.content_dom
    @office_text = @document.content_root

    # the different nodes in our document, needed for each magic
    @nodes = @office_text.child_nodes
  end

  # create a file and immideatly get to work
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
    file_path << FILE_ENDING if File.extname(file_path) != FILE_ENDING
    @document.save file_path

    # it normally returns nil, but some people like to use save in if-statements
    self
  end

  # Create a new paragraph with the given text.
  # If no text is given, just create a paragraph
  # if a style is supplied use that one, default styles should be symbols
  # user defined styles should be strings
  def add_paragraph(text=nil, style=nil)
    if text == nil
      paragraph = OdfTextParagraph.new(@content_dom)
    elsif style == nil
      paragraph = OdfTextParagraph.new(@content_dom).add_content(text)
    else
      if style.instance_of? String
        paragraph = OdfTextParagraph.new(@content_dom, style, text)
      else
        paragraph = OdfTextParagraph.new(@content_dom,
                                         DEFAULT_STYLES[style],
                                         text)
      end
    end

    # append the created paragraph to the document
    @office_text.append_child(paragraph)
    self
  end

  # Text is just added to the last paragraph, no new paragraph created
  def add_text(text)
    @document.add_text text
    self
  end

  def add_heading(text)
    add_paragraph(text, :heading)
    self
  end

  def document_styles
    @document_styles || OpenOfficeStyles.new(
                                      @document.get_or_create_document_styles)
  end

  # shortcut for defining new styles on the document
  def new_style(*args, &block)
    document_styles.new_style(*args, &block)
  end

  # iterate over each element of the content
  def each
    (0...@nodes.length).each { |i| yield @nodes.item(i) }
    self
  end

  # the number of elements in the document
  def size
    @nodes.length
  end

  private

  # it appears as if there are already 122 paragraph styles to use...
  # but well I'll leave it in here for now :-)
  def create_default_styles

    document_styles.new_style(DEFAULT_STYLES[:bold], :paragraph) do
      display_name "Bold Paragraph"
      font_weight "bold"
      font_size DEFAULT_FONT_SIZE
    end

    document_styles.new_style(DEFAULT_STYLES[:italic], :paragraph) do
      display_name "Italic Paragraph"
      font_size DEFAULT_FONT_SIZE
      font_style "italic"
    end

    document_styles.new_style(DEFAULT_STYLES[:heading], :paragraph) do
      display_name = "Simple Heading"
      font_size "24pt"
    end

  end

  alias_method :<<, :add_paragraph

end

