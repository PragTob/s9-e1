require 'java'
require_relative 'open_style'
require_relative '../../vendor/odfdom-java-0.8.7-jar-with-dependencies.jar'

java_import org.odftoolkit.odfdom.dom.style.OdfStyleFamily

module ODFDOM
  class OpenOfficeStyles

    STYLE_FAMILIES = {
      paragraph: OdfStyleFamily::Paragraph,
      text: OdfStyleFamily::Text,
      ruby: OdfStyleFamily::Ruby,
      list: OdfStyleFamily::List,
      table: OdfStyleFamily::Table,
      table_cell: OdfStyleFamily::TableCell,
      table_row: OdfStyleFamily::TableRow
    }

    # initialized given an original OdfOfficeStyles object
    def initialize(styles)
      @styles = styles
    end

    def new_style(name, family, &block)
      OpenStyle.new(@styles.new_style(name, STYLE_FAMILIES[family]), &block)
    end

    def styles_for_family(family)
      java_styles = @styles.get_styles_for_family(STYLE_FAMILIES[family])

      java_styles.map { |style| OpenStyle.new(style) }
    end

  end
end

