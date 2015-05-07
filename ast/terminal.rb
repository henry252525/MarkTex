class Terminal

  def initialize(text)
    @text = text
  end

  # TODO: Make this faster (regex is slow)
  # TODO: Emphasis
  RESERVED_CHARACTERS = [
    '_', '#', '%' # '//'
  ]
  def self.character_escape(text)
    # backslashes are weird, since they are evaluated twice by gsub and 
    # everything gets super confusing. We just handle the case explicitly here.
    text.gsub!('\\', '\\\\\\')

    RESERVED_CHARACTERS.each do |char|
      text.gsub!(char, "\\#{char}")
    end


    text
  end

  def to_s
    self.class.character_escape @text
  end

end
