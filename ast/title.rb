class Title
  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    return "" if @title.nil?
    [
      "\\title{#{@title}}",
      @author.empty? ? "\\author{#{@author}}" : nil,
      "\\maketitle"
    ].reject(nil).join("\n")
  end
end
