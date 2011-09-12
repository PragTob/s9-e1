# Integration Exercise: Java Library Wrapper

I am wrapping the [ODFDOM] (http://odftoolkit.org/projects/odfdom/pages/Home).
It's a library for creating and modifying Open Document files. So spreadsheets,
texts and presentations. Not sure if all of these will be in the final release.
For now it's just text files as this was already difficult enough...

*ODF* stands for Open Document Format

Btw. ODFDOM seems to have a pretty decent [beginners guide]
(http://www.langintro.com/odfdom_tutorials/index.html).
The javadoc may be found [here]
(http://odfdom.odftoolkit.org/0.8.7/odfdom/apidocs/index.html)

## Attention!
You got to use JRuby in 1.9 mode... so please do
    jruby --1.9
or (if you want this to be your permanent mode)
    export JRUBY_OPTS=--1.9

## Usage
    require 'odfdom'

    # simply creating and saving a file
    my_document = OpenTextDocument.new
    my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
    my_document.save "Tobi.odt"
    my_document.close

    # you may also add to already existing documents!
    # if a file name is specified, files get saved automatically
    # also the file gets saved automatically
    OpenTextDocument.new "Tobi.odt" do
      add_paragraph "Yeah it really is a nice day!"
    end

    # You can also create documents
    # you don't need to supply a file ending, this nice gem adds it for you!
    OpenTextDocument.create "nonexisting" do
      self << "I don't exist!" << "but you just created me!" << "That's awesome!"
    end

    # And you may also use some of the default styles
    OpenTextDocument.create "styles" do
      add_heading "I am sooo big!"
      add_paragraph("I am feeling bold today", :bold)
      add_paragraph("I am italic", :italic)

      # or define a new style
      new_style("special heading", :paragraph) do
        font_size "24pt"
        font_weight "bold"
        font_style "italic"
        display_name "Bold Italic Headline"
      end

      # refer to the style by name
      add_paragraph("Look at me, I am so beautiful!", "special heading")
    end

## Exercise Summary

- You should create a gem using JRuby that wraps an existing Java library.
- Your gem should work with a Java library that doesn't already have
  a good wrapper.
- You should make the API for your library look and feel like Ruby, not Java.

