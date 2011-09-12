require 'java'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.incubator.doc.style.OdfStyle
java_import org.odftoolkit.odfdom.dom.element.style.StyleTextPropertiesElement

# A single style for open documents
class OpenStyle

  # initialize given our style and optionally a block to getto work immideatly
  def initialize(style, &block)
    @style = style
    instance_eval(&block) if block_given?
  end

  # Set/get the display name (it's a dual purpose accessor, you'll see more of
  # them)
  def display_name(name=nil)
    if name
      @style.style_display_name_attribute = name
    else
      @style.style_display_name_attribute
    end
  end

  # REMARK: the next 3 setter parts are so verbose for internationalization
  # reasons idea taken from the odfdom tutorial
  # http://www.langintro.com/odfdom_tutorials/create_odt.html

  def font_weight(value=nil)
    if value
      @style.set_property(StyleTextPropertiesElement::FontWeight, value)
		  @style.set_property(StyleTextPropertiesElement::FontWeightAsian, value)
		  @style.set_property(StyleTextPropertiesElement::FontWeightComplex, value)
    else
      @style.get_property(StyleTextPropertiesElement::FontWeight)
    end
  end

  def font_style(value=nil)
    if value
      @style.set_property(StyleTextPropertiesElement::FontStyle, value)
		  @style.set_property(StyleTextPropertiesElement::FontStyleAsian, value)
		  @style.set_property(StyleTextPropertiesElement::FontStyleComplex, value)
    else
      @style.get_property(StyleTextPropertiesElement::FontStyle)
    end
  end

  def font_size(value=nil)
    if value
      @style.set_property(StyleTextPropertiesElement::FontSize, value)
	  	@style.set_property(StyleTextPropertiesElement::FontSizeAsian, value)
		  @style.set_property(StyleTextPropertiesElement::FontSizeComplex, value)
    else
      @style.get_property(StyleTextPropertiesElement::FontSize)
    end
  end

  # aliasing to also get the other cool setters
  alias_method :display_name=, :display_name
  alias_method :font_weight=, :font_weight
  alias_method :font_size=, :font_size
  alias_method :font_style=, :font_style

end

