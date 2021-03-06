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
    my_document = ODFDOM::OpenTextDocument.new
    my_document << "Hello Tobi!" << "How are you?" << "Isn't it a nice day?"
    my_document.save "Tobi.odt"
    my_document.close

    # you may also add to already existing documents!
    # if a file name is specified, files get saved automatically
    # also the file gets saved automatically
    ODFDOM::OpenTextDocument.new "Tobi.odt" do
      paragraph "Yeah it really is a nice day!"
    end

    # You can also create documents
    # you don't need to supply a file ending, this nice gem adds it for you!
    ODFDOM::OpenTextDocument.new "nonexisting" do
      paragraph "I don't exist!"
      paragraph "but you just created me!"
      paragraph "That's awesome!""
    end

    # And you may also use some of the default styles
    ODFDOM::OpenTextDocument.new "styles" do
      heading "I am sooo big!"
      paragraph("I am feeling bold today", :bold)
      paragraph("I am italic", :italic)

      # or define a new style
      style("special heading", :paragraph) do
        font_size "24pt"
        font_weight "bold"
        font_style "italic"
        display_name "Bold Italic Headline"
      end

      # refer to the style by name
      paragraph("Look at me, I am so beautiful!", "special heading")

      each { |each| puts each }
    end

# Known Problems
My libre office takes pretty long to start up with the created files. Dunno what
that is about. But it starts and no crashes, if you notice anything please
contact me or open an issue.

## Exercise Summary

- You should create a gem using JRuby that wraps an existing Java library.
- Your gem should work with a Java library that doesn't already have
  a good wrapper.
- You should make the API for your library look and feel like Ruby, not Java.

