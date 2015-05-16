class Underline

  def initialize(inlines)
    @inlines = inlines
  end

  def to_s
    [
      '\uline{',
      @inlines.map(&:to_s),
      '}'
    ].flatten.join
  end

end
