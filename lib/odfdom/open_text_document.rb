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
  DEFAULT_STYLES = { bold: "bold", normal: "normal" }

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
  def add_paragraph(text=nil, style=nil)

    if text == nil
      paragraph = OdfTextParagraph.new(@content_dom)
    elsif style == nil
      paragraph = OdfTextParagraph.new(@content_dom).add_content(text)
    else
      paragraph = OdfTextParagraph.new(@content_dom,
                                       DEFAULT_STYLES[style],
                                       text)
    end
    @office_text.append_child(paragraph)
    self
  end

  def <<(*args)
    add_paragraph(*args)
  end

  # Text is just added to the last paragraph, no new paragraph created
  def add_text(text)
    @document.add_text text
    self
  end

  def document_styles
    @document_styles || OpenOfficeStyles.new(
                                      @document.get_or_create_document_styles)
  end

  private

  def create_default_styles
    document_styles.new_style("bold", :paragraph) do
      display_name = "bold Paragraph"
      font_weight = "bold"
      font_size = "30pt"
    end

    stylo = document_styles.new_style("italic", :paragraph)
    stylo.display_name = "ahjaaa"
    stylo.font_size = "14pt"
    stylo.font_weight = "bold"

    document_styles.new_style("normal", :paragraph) do
      display_name = "Normal"
    end
  end

end

