class Bold

  def initialize(inlines)
    @inlines = inlines
  end

  def to_s
    [
      '\textbf{',
      @inlines.map(&:to_s),
      '}'
    ].flatten.join
  end

end
