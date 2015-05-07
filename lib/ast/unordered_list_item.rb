require_relative 'helpers'

class UnorderedListItem
  def initialize(children)
    @children = children
  end

  def to_s
    Helpers::blocks_to_s @children
  end
end
