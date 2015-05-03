class Header
  def initialize(child)
    @child = child
  end

  def to_s
    child.to_s
  end
end