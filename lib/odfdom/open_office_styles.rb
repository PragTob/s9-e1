require 'java'
require_relative 'open_style'
require_relative '../../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.incubator.doc.office.OdfOfficeStyles
java_import org.odftoolkit.odfdom.dom.style.OdfStyleFamily

# the node defining the styles of an open office document
class OpenOfficeStyles

  STYLE_FAMILIES = {
                    paragraph: OdfStyleFamily::Paragraph,
                    text: OdfStyleFamily::Text,
                    ruby: OdfStyleFamily::Ruby, # I have no idea what this is
                    list: OdfStyleFamily::List,
                    table: OdfStyleFamily::Table,
                    table_cell: OdfStyleFamily::TableCell,
                    table_row: OdfStyleFamily::TableRow }

  # initialize using the corresponding java Object
  def initialize java_office_styles_object
    @styles = java_office_styles_object
  end

  # create a new style given it's identifier and the family it belongs to
  def new_style(name, family, &block)
    OpenStyle.new(@styles.new_style(name, STYLE_FAMILIES[family]), &block)
  end

  def styles_for_family(family)
    java_styles_iterator = @styles.get_styles_for_family(STYLE_FAMILIES[family])

    #create an array with our own style classes
    java_styles_iterator.inject([]) { |sum, style| sum << OpenStyle.new(style) }
  end

end

