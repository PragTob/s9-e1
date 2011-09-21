module ODFDOM
  class OpenTextParagraph

    def initialize(java_paragraph)
      @paragraph = java_paragraph
    end

    def to_s
      @paragraph.text_content
    end

    def style
      @paragraph.style_name
    end

    alias_method :content, :to_s
    alias_method :text, :to_s

  end
end

