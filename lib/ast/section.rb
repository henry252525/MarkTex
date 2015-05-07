class Section
  def initialize(text)
    @text = text
  end

  def to_s
    "\\section{#{@text.to_s}}"
  end
end
