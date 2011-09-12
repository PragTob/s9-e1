require 'java'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.incubator.doc.style.OdfStyle
java_import org.odftoolkit.odfdom.dom.element.style.StyleTextPropertiesElement

class OpenStyle

  # initialize given our style
  def initialize style
    @style = style
  end

  def display_name=(name)
    @style.style_display_name_attribute = name
  end

  # REMARK: the next 3 methods exist for internationalization reasons
  # idea taken from the odfdom tutorial
  # http://www.langintro.com/odfdom_tutorials/create_odt.html

  def font_weight=(value)
    @style.set_property(StyleTextPropertiesElement::FontWeight, value);
		@style.set_property(StyleTextPropertiesElement::FontWeightAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontWeightComplex, value);
  end

  def font_style=(value)
    @style.set_property(StyleTextPropertiesElement::FontStyle, value);
		@style.set_property(StyleTextPropertiesElement::FontStyleAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontStyleComplex, value);
  end

  def font_size=(value)
    @style.set_property(StyleTextPropertiesElement::FontSize, value);
		@style.set_property(StyleTextPropertiesElement::FontSizeAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontSizeComplex, value);
  end

end

