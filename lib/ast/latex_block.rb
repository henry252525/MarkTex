class LatexBlock
  def initialize(latex)
    @latex = latex
  end

  def to_s
    @latex.join("\n")
  end
end
