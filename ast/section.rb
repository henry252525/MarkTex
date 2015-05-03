class Section
  def initialize(data)
    @data = data
  end

  def to_s
    "\\section{#{@data}}"
  end
end