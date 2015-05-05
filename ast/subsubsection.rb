class Subsubsection

  def initialize(data)
    @data = data
  end

  def to_s
    "\\subsubsection{#{@data}}"
  end

end
