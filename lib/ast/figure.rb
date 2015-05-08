# TODO: Add tests
class Figure
  def initialize(caption, path)
    @caption = caption
    @path = path
  end

  # TODO: Caption should be from Text AST
  def to_s
    [
      '\begin{figure}[H]',
      '  \centering',
      "  \\includegraphics[width=0.6\\textwidth]\{\"#{@path}\"\}",
      @caption.empty? ? nil : "  \\caption\{#{@caption}\}",
      '\end{figure}'
    ].reject(&:nil?).join("\n")
  end
end
