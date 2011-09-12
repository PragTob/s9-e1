require 'java'
require '../bin/odfdom-java-0.8.7-jar-with-dependencies.jar'
java_import org.odftoolkit.odfdom.incubator.doc.style.OdfStyle
java_import org.odftoolkit.odfdom.dom.element.style.StyleTextPropertiesElement

class OpenStyle

  # initialize given our style
  def initialize(style)
    @style = style
    puts "We also got a block here!" if block_given?
   # instance_eval(&block) if block_given?
  end

  def display_name=(name)
    @style.style_display_name_attribute = name
  end

  def display_name(name=nil)
    if name
      self.display_name = name
    else
      @style.style_display_name_attribute
    end
  end

  # REMARK: the next 3 methods exist for internationalization reasons
  # idea taken from the odfdom tutorial
  # http://www.langintro.com/odfdom_tutorials/create_odt.html

  def font_weight=(value)
    @style.set_property(StyleTextPropertiesElement::FontWeight, value);
		@style.set_property(StyleTextPropertiesElement::FontWeightAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontWeightComplex, value);
  end

  def font_weight(value=nil)
    if value
      self.font_weight = value
    else
      @style.get_property(StyleTextPropertiesElement::FontWeight)
    end
  end

  def font_style=(value)
    @style.set_property(StyleTextPropertiesElement::FontStyle, value);
		@style.set_property(StyleTextPropertiesElement::FontStyleAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontStyleComplex, value);
  end

  def font_style(value=nil)
    if value
      self.font_style = value
    else
      @style.get_property(StyleTextPropertiesElement::FontStyle)
    end
  end

  def font_size=(value)
    @style.set_property(StyleTextPropertiesElement::FontSize, value);
		@style.set_property(StyleTextPropertiesElement::FontSizeAsian, value);
		@style.set_property(StyleTextPropertiesElement::FontSizeComplex, value);
  end

  def font_size(value=nil)
    if value
      self.font_size = value
    else
      @style.get_property(StyleTextPropertiesElement::FontSize)
    end
  end

end

