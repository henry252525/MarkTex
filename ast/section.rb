class Section

  EXPRESSION = /^#\s*(.*)$/

  def self.parse(input)
    match = EXPRESSION.match input
    if match
      return self.new(match[1])
    end
    return nil
  end

  def initialize(data)
    @data = data
  end

  def to_s
    "\\section{#{@data}}"
  end
end
