class Title
  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    return "" if @title.nil?
    [
      "\\title{#{@title}}",
      @author.empty? ? nil : "\\author{#{@author}}",
      "\\maketitle"
    ].reject(&:nil?).join("\n")
  end
end
