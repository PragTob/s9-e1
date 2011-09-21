module ODFDOM
  # the base class for all open Documents, offering basic methods
  module OpenDocument

    # this removes ALL nodes in the document
    # so afterwards the document is empty
    def clear_document
      content_root = @document.content_root
      node = content_root.first_child

     content_root.remove_child(node)  while node = content_root.first_child
    end

    # close the document
    # be aware of the fact that this renders the object useless
    def close
      @document.close
    end

  end
end

