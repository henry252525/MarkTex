class Subsection
  def initialize(data)
    @data = data
  end

  def to_s
    "\\subsection{#{@data}}"
  end
end