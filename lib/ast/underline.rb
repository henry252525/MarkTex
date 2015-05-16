class Underline

  def initialize(inlines)
    @inlines = inlines
  end

  # \uline{} was used for underlining LaTeX since it carries over underlining
  # from the first line
  def to_s
    [
      '\uline{',
      @inlines.map(&:to_s),
      '}'
    ].flatten.join
  end

end
