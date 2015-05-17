class CodeInline

  def initialize(terminal)
    @terminal = terminal
  end

  def to_s
    "\\texttt{#{@terminal.to_s}}"
  end

end
