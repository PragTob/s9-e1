# the base class for all open Documents, offering basic methods
class OpenDocument

  # this removes ALL nodes in the document
  # so afterwards the document is empty
  def clear_document
    content_root = @document.content_root
    node = content_root.first_child

    while node != nil
      content_root.remove_child node
      node = content_root.first_child
    end
  end

  # close the document
  # be aware of the fact that this renders the object useless
  def close
    @document.close
  end

end

