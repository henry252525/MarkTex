class Italic

  def initialize(inlines)
    @inlines = inlines
  end

  def to_s
    [
      '\textit{',
      @inlines.map(&:to_s),
      '}'
    ].flatten.join
  end

end
