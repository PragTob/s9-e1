require 'java'
require 'odfdom/open_document'
require 'odfdom/open_office_styles'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument
java_import org.odftoolkit.odfdom.incubator.doc.text.OdfTextParagraph
java_import org.odftoolkit.odfdom.dom.OdfContentDom
#java_import org.odftoolkit.odfdom.dom.element.office.OfficeTextElement

class OpenTextDocument < OpenDocument

  FILE_ENDING = ".odt"
  DEFAULT_STYLES = { bold: "bold", italic: "italic", heading: "heading" }
  DEFAULT_FONT_SIZE = "12pt"

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

    @content_dom = @document.content_dom
    @office_text = @document.content_root

    create_default_styles

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
  end

  def document_styles
    @document_styles || OpenOfficeStyles.new(
                                      @document.get_or_create_document_styles)
  end

  def new_style(*args, &block)
    document_styles.new_style(*args, &block)
  end

  private

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

