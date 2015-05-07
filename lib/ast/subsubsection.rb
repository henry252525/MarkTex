class Subsubsection

  def initialize(text)
    @text = text
  end

  def to_s
    "\\subsubsection{#{@text.to_s}}"
  end

end
