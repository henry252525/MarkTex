class Document
  def initialize(children)
    @children = children
  end

  def to_s
    @children.map { |b| b.to_s }.join("\n")
  end
end
