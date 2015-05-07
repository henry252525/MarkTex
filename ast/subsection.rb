class Subsection
  def initialize(text)
    @text = text
  end

  def to_s
    "\\subsection{#{@text.to_s}}"
  end
end
