require 'java'

require_relative 'open_document'
require_relative 'open_office_styles'
require_relative 'open_text_paragraph'
require_relative '../../ext/odfdom-java-0.8.7-jar-with-dependencies.jar'

java_import org.odftoolkit.odfdom.doc.OdfTextDocument
java_import org.odftoolkit.odfdom.incubator.doc.text.OdfTextParagraph
java_import org.odftoolkit.odfdom.dom.OdfContentDom

module ODFDOM
  class OpenTextDocument
    include Enumerable
    include OpenDocument

    FILE_ENDING = ".odt"
    DEFAULT_STYLES = { bold: "bold", italic: "italic", heading: "heading" }
    DEFAULT_FONT_SIZE = "12pt"

    def initialize(file_path=nil, &block)
      create(file_path)
      create_default_styles
      evaluate_block(file_path, &block) if block_given?
    end

    def save(file_path)
      file_path << FILE_ENDING if File.extname(file_path) != FILE_ENDING
      @document.save(file_path)

      # it normally returns nil, but some people like to use save in if
      self
    end

    def paragraph(text=nil, style=nil)
      paragraph = if text.nil?
                    OdfTextParagraph.new(content_dom)
                  elsif style.nil?
                    OdfTextParagraph.new(content_dom).add_content(text)
                  else
                    OdfTextParagraph.new(content_dom,
                      DEFAULT_STYLES[style] || style,
                      text)
                  end

      office_text.append_child(paragraph)
      self
    end

    alias_method :para, :paragraph
    alias_method :p, :paragraph
    alias_method :<<, :paragraph

    # Text is just added to the last paragraph, no new paragraph/node created
    def text(text)
      @document.add_text(text)
      self
    end

    def heading(text)
      paragraph(text, :heading)
      self
    end

    def document_styles
      @document_styles || OpenOfficeStyles.new(
        @document.get_or_create_document_styles)
    end

    def style(*args, &block)
      document_styles.new_style(*args, &block)
    end

    def each
      size.times do |i|
        current_node = nodes.item(i)
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

    def size
      nodes.length
    end

    private

    def create(file_path)
      if file_path && File.exist?(file_path)
        @document = OdfTextDocument.loadDocument(file_path)
      else
        @document = OdfTextDocument.new_text_document
        # documents start out with an empty paragraph, we don't want that
        clear
      end
    end

    def nodes
      office_text.child_nodes
    end

    def content_dom
      @document.content_dom
    end

    def office_text
      @document.content_root
    end

    def evaluate_block(file_path, &block)
      begin
        instance_eval(&block)

        save(file_path) if file_path
      ensure
        close
      end
    end

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
        display_name "Simple Heading"
        font_size "24pt"
      end
    end

  end
end

