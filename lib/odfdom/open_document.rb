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

end

