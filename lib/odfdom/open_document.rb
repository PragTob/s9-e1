module ODFDOM
  module OpenDocument

    def clear
      content_root = @document.content_root
      node = content_root.first_child

      content_root.remove_child(node)  while node = content_root.first_child
    end

    def close
      @document.close
    end

  end
end

