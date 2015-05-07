class UnorderedList
  def initialize(children)
    @children = children
  end

  def to_s
    # TODO: Make it look pretty when printed
    list_items = @children.map do |child|
      "  \\item #{child.to_s}"
    end

    [ '\begin{itemize}',
      list_items,
      '\end{itemize}'
    ].flatten.join("\n")

  end
end
