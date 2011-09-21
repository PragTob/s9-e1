require 'java'
require_relative '../../ext/odfdom-java-0.8.7-jar-with-dependencies.jar'

java_import org.odftoolkit.odfdom.incubator.doc.style.OdfStyle
java_import org.odftoolkit.odfdom.dom.element.style.StyleTextPropertiesElement

module ODFDOM
  class OpenStyle

    # initialized given an original OdfStyle object
    def initialize(style, &block)
      @style = style
      instance_eval(&block) if block_given?
    end

    def display_name(name=nil)
      return @style.style_display_name_attribute unless name
      @style.style_display_name_attribute = name
    end

    alias_method :display_name=, :display_name

    def name(name=nil)
      return @style.style_name_attribute unless name
      @style.style_name_attribute = name
    end

    alias_method :name=, :name

    def allow_symbols_as_values(value)
      value = value.to_s
    end

    # REMARK: the next 3 setter parts are so verbose for internationalization
    # reasons idea taken from the odfdom tutorial
    # http://www.langintro.com/odfdom_tutorials/create_odt.html

    def font_weight=(value)
      allow_symbols_as_values(value)
      @style.set_property(StyleTextPropertiesElement::FontWeight, value)
      @style.set_property(StyleTextPropertiesElement::FontWeightAsian, value)
      @style.set_property(StyleTextPropertiesElement::FontWeightComplex, value)
    end

    def font_weight(value=nil)
      self.font_weight = value if value
      @style.get_property(StyleTextPropertiesElement::FontWeight)
    end

    def font_style=(value)
      allow_symbols_as_values(value)
      @style.set_property(StyleTextPropertiesElement::FontStyle, value)
      @style.set_property(StyleTextPropertiesElement::FontStyleAsian, value)
      @style.set_property(StyleTextPropertiesElement::FontStyleComplex, value)
    end

    def font_style(value=nil)
      self.font_style = value if value
      @style.get_property(StyleTextPropertiesElement::FontStyle)
    end

    def font_size=(value)
      @style.set_property(StyleTextPropertiesElement::FontSize, value)
      @style.set_property(StyleTextPropertiesElement::FontSizeAsian, value)
      @style.set_property(StyleTextPropertiesElement::FontSizeComplex, value)
    end

    def font_size(value=nil)
      self.font_size = value if value
      @style.get_property(StyleTextPropertiesElement::FontSize)
    end

  end
end

