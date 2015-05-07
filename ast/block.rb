class Block
  attr_reader :child

  def initialize(child)
    @child = child
  end

  def to_s
    @child.to_s
  end
end
