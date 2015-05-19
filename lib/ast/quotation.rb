class Quotation

  def initialize(inlines)
    @inlines = inlines
  end

  def to_s
    [
      "``",
      @inlines.map(&:to_s),
      "''"
    ].flatten.join
  end

end
