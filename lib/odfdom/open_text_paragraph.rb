module ODFDOM
  class OpenTextParagraph

    # initialized given an original OdfTextParagraph object
    def initialize(paragraph)
      @paragraph = paragraph
    end

    def text
      @paragraph.text_content
    end

    def style
      @paragraph.style_name
    end

    alias_method :to_s, :text

  end
end

