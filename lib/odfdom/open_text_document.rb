require 'java'
require_relative 'open_document'
require_relative 'open_office_styles'
require_relative 'open_text_paragraph'
require_relative '../../ext/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.doc.OdfTextDocument
java_import org.odftoolkit.odfdom.incubator.doc.text.OdfTextParagraph
java_import org.odftoolkit.odfdom.dom.OdfContentDom

# A normal open text document where you can add paragraphs etc.
class OpenTextDocument
  include Enumerable
  include OpenDocument

  FILE_ENDING = ".odt"
  DEFAULT_STYLES = { bold: "bold", italic: "italic", heading: "heading" }
  DEFAULT_FONT_SIZE = "12pt"

  # create a new document or to load an existing one, if a path is given
  def initialize(file_path=nil, &block)
    create_the_basic_document(file_path)
    set_important_instance_variables
    create_default_styles
    evaluate_block(file_path, &block) if block_given?
  end

  # Save the document to the given path
  # you don't even have to supply the .odt every time
  def save(file_path)
    file_path << FILE_ENDING if File.extname(file_path) != FILE_ENDING
    @document.save file_path

    # it normally returns nil, but some people like to use save in if-statements
    self
  end

  def add_paragraph(text=nil, style=nil)
    paragraph = if text.nil?
                  OdfTextParagraph.new(@content_dom)
                elsif style.nil?
                  OdfTextParagraph.new(@content_dom).add_content(text)
                else
                  OdfTextParagraph.new(@content_dom,
                    DEFAULT_STYLES[style] || style,
                    text)
                end

    @office_text.append_child(paragraph)
    self
  end

  alias_method :add_p, :add_paragraph
  alias_method :<<, :add_paragraph

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
    (0...size).each do |i|
      current_node = @nodes.item(i)
      if current_node.kind_of?(
        Java::OrgOdftoolkitOdfdomIncubatorDocText::OdfTextParagraph)
        # we got a wrapper for that!
        yield OpenTextParagraph.new(current_node)
      else
        yield current_node
      end
    end
    self
  end

  # the number of elements in the document (paragraphs etc.)
  def size
    @nodes.length
  end

  private

  def create_the_basic_document(file_path)
    if file_path && File.exist?(file_path)
      @document = OdfTextDocument.loadDocument file_path
    else
      @document = OdfTextDocument.newTextDocument
      # documents start out with an empty paragraph, we don't want that
      clear_document
    end
  end

  def set_important_instance_variables
    # most of the Java methods need these two for their functionality
    @content_dom = @document.content_dom
    @office_text = @document.content_root

    # the different nodes in our document, needed for each magic
    @nodes = @office_text.child_nodes
  end

  def evaluate_block(file_path, &block)
    begin
      instance_eval(&block)
      # automatically save the file if a file_path is given
      save(file_path) if file_path
    ensure
      close
    end
  end

  # it appears as if there are already 122 paragraph styles to use...
  # but well I'll leave it in here for now :-)
  def create_default_styles
    create_bold_style
    create_italic_style
    create_heading_style
  end

  def create_bold_style
    document_styles.new_style(DEFAULT_STYLES[:bold], :paragraph) do
      display_name "Bold Paragraph"
      font_weight "bold"
      font_size DEFAULT_FONT_SIZE
    end
  end

  def create_italic_style
    document_styles.new_style(DEFAULT_STYLES[:italic], :paragraph) do
      display_name "Italic Paragraph"
      font_size DEFAULT_FONT_SIZE
      font_style "italic"
    end
  end

  def create_heading_style
    document_styles.new_style(DEFAULT_STYLES[:heading], :paragraph) do
      display_name = "Simple Heading"
      font_size "24pt"
    end
  end

end

