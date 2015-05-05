class UnorderedListItem
  def initialize(children)
    @children = children
  end

  def to_s
    list_items = []
    @children.each_with_index do |e, i|
      cur_is_par = e.instance_of?(Paragraph)
      next_is_par = @children[i+1].instance_of?(Paragraph)

      if i < @children.size && cur_is_par && next_is_par
        list_items.push "#{e} \\\\"
      else
        list_items.push e
      end
    end
    list_items.join("\n\n")
  end
end
