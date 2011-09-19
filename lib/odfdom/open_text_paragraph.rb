# Wrapper for OdfTextParagraph, it is however only used when the pargraph
# is returned to the user of the library, otherwise OpenTextDocument works with
# the native java class.
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

