class Paragraph

  def initialize(inlines)
    @inlines = inlines
  end

  def self.initialize_empty
    @inlines = []
  end

  def to_s
    @inlines.map(&:to_s).join ' '
  end
end
