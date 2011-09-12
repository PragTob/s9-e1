require 'java'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.incubator.doc.style.OdfStyle
java_import org.odftoolkit.odfdom.dom.style.props.OdfStylePropertiesSet

class OpenStyle

  # initialize given our style
  def initialize style
    @style = style
  end

  # REMARK: the next 3 methods exist for internationalization reasons
  # idea taken from the odfdom tutorial
  # http://www.langintro.com/odfdom_tutorials/create_odt.html

  def font_weight(value)
    @style.property(OdfStylePropertiesSet.TextProperties.FontWeight, value);
		@style.property(OdfStyleTextProperties.FontWeightAsian, value);
		@style.property(OdfStyleTextProperties.FontWeightComplex, value);
  end

  def font_style(value)
    @style.property(OdfStyleTextProperties.FontStyle, value);
		@style.property(OdfStyleTextProperties.FontStyleAsian, value);
		@style.property(OdfStyleTextProperties.FontStyleComplex, value);
  end

  def font_size(value)
    @style.property(OdfStyleTextProperties.FontSize, value);
		@style.property(OdfStyleTextProperties.FontSize, value);
		@style.property(OdfStyleTextProperties.FontSize, value);
  end

end

