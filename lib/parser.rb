MARKTEX_FILE_PATH = File.expand_path(File.dirname(__FILE__))
Dir[MARKTEX_FILE_PATH + '/ast/*.rb'].each {|file| require file }

module Parser
  def self.document_parse(input)
    title = title_parse(input)

    blocks = []
    until input.empty? do
      # TODO: quick fix to handle empty lines in input
      while input.first.strip.empty?
        input.shift
      end
      current_block = block_parse input
      if current_block.nil?
        abort("Error parsing")
      else
        blocks.push current_block
      end
    end
    Document.new(title, blocks)
  end

  TITLE_EXPR = '~title: '
  AUTHOR_EXPR = '~author: '

  def self.title_parse(input)
    if input.first.start_with?(TITLE_EXPR)
      title = input.first[TITLE_EXPR.length..-1]
      input.shift
    end

    if input.first.start_with?(AUTHOR_EXPR)
      author = input.first[AUTHOR_EXPR.length..-1]
      input.shift
    end

    Title.new(title, author)
  end

  def self.block_parse(input)
    child = header_parse(input) ||
        latex_block_parse(input) ||
        unordered_list_parse(input) ||
        self.figure_parse(input) ||
        paragraph_parse(input)
    return nil if child.nil?
    Block.new child
  end

  SUBSUBSECTION_EXPRESSION = /^###\s*(.*)$/
  SUBSECTION_EXPRESSION = /^##\s*(.*)$/
  SECTION_EXPRESSION = /^#\s*(.*)$/

  SECTION_PARSING_LIST = [
    [Subsubsection, SUBSUBSECTION_EXPRESSION],
    [Subsection, SUBSECTION_EXPRESSION],
    [Section, SECTION_EXPRESSION]
  ]

  def self.header_parse(input)
    SECTION_PARSING_LIST.each do |cls, expression|
      match = expression.match input[0]
      if match
        input.shift
        return cls.new(Terminal.new(match[1]))
      end
    end

    return nil
  end

  # TODO: Make more robust by perhaps keeping a stack of braces
  LATEX_BLOCK_START_EXPRESSION = "~latex{"
  LATEX_BLOCK_END_EXPRESSION = "}"
  def self.latex_block_parse(input)
    if input.first != LATEX_BLOCK_START_EXPRESSION
      return nil
    end
    input.shift
    raw_latex = []
    until input.first == LATEX_BLOCK_END_EXPRESSION
      raw_latex.push input.shift[2..-1]
    end
    input.shift
    LatexBlock.new raw_latex
  end

  UNORDERED_LIST_TOKENS = ['* ', '- ']
  def self.unordered_list_parse(input)
    return nil unless input.first.start_with?(*UNORDERED_LIST_TOKENS)
    list_input = []

    while !input.empty?
      is_list_item = input.first.start_with?(*UNORDERED_LIST_TOKENS)
      is_indented = input.first.start_with?('  ')
      is_blank_line = input.first.strip.empty?

      break unless is_list_item || is_indented || is_blank_line
      list_input.push input.shift
    end

    children = []
    until list_input.empty?
      list_item_input = []
      loop do
        next_line = list_input.shift[2..-1] || ''
        list_item_input.push next_line
        break if list_input.empty? || list_input.first.start_with?(*UNORDERED_LIST_TOKENS)
      end
      children.push(unordered_list_item_parse list_item_input)
    end
    UnorderedList.new children
  end

  def self.unordered_list_item_parse(input)
    children = []
    until input.empty?
      child = latex_block_parse(input) ||
          unordered_list_parse(input) ||
          self.figure_parse(input) ||
          paragraph_parse(input)
      children.push(Block.new(child)) unless child.nil?
    end
    children.push(Block.new(Paragraph.new(Terminal.new('')))) if children.empty?

    UnorderedListItem.new children
  end

  FIGURE_EXPRESSION = "!["
  # TODO: Handle brackets within caption
  FIGURE_REGEX = /\!\[(.*)\]\((.*)\)/
  def self.figure_parse(input)
    return nil unless input.first.start_with? FIGURE_EXPRESSION

    _, caption, path = FIGURE_REGEX.match(input.shift).to_a

    Figure.new caption, path
  end

  # TODO: Do not repeat unordered list tokens
  FORBIDDEN_STRINGS = [
    '#',
    '- ',
    '* ',
    '~latex{'
  ]
  def self.paragraph_parse(input)
    data = []
    until input.empty? do
      if input.first.empty?
        input.shift
        break
      end
      should_break = false
      FORBIDDEN_STRINGS.each do |s|
        should_break = input.first.start_with? s
        break if should_break
      end
      break if should_break
      data.push input.shift
    end

    return nil if data.empty?
    Paragraph.new Terminal.new(data.join(' '))
  end
end
