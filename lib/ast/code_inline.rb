class CodeInline

  def initialize(inlines)
    @inlines = inlines
  end

  def to_s
    [
      '\texttt{',
      @inlines.map(&:to_s),
      '}'
    ].flatten.join
  end

end
