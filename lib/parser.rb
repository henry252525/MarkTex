MARKTEX_FILE_PATH = File.expand_path(File.dirname(__FILE__))
Dir[MARKTEX_FILE_PATH + '/ast/*.rb'].each {|file| require file }

require 'set'

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
        figure_parse(input) ||
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
    children.push(Block.new(Paragraph.initialize_empty)) if children.empty?

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
    '~latex{',
    '!['
  ]
  def self.paragraph_parse(input)
    inlines = []
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
      inlines.push inlines_parse(input.shift.chars).map(&:to_s).join
    end

    return nil if inlines.empty?
    Paragraph.new inlines.flatten
  end

  def self.inlines_parse(characters)
    children = []

    until characters.empty? do
      children.push(
        bold_parse(characters) ||
        italic_parse(characters) ||
        terminal_parse(characters)
      )
    end

    children.map { |child| Inline.new child }
  end


  RESERVED_INLINE_CHARACTERS = Set.new([
    '*', '/'
  ])
  def self.terminal_parse(characters)
    parsed_characters = []

    until characters.empty? || RESERVED_INLINE_CHARACTERS.include?(characters.first) do
      parsed_characters.push characters.shift
    end

    return if parsed_characters.empty?

    Terminal.new(parsed_characters.join)
  end

  def self.bold_parse(characters)
    inline_element_parse('*', Bold, characters)
  end

  def self.italic_parse(characters)
    inline_element_parse('/', Italic, characters)
  end

  def self.inline_element_parse(wrap_symbol, ast_type, characters)
    return unless characters.first == wrap_symbol && characters[1] != ' '

    characters.shift(1)  # remove the first wrap symbol

    end_of_inline_element_index = nil
    characters.each_with_index do |c, i|
      next if i == 0
      if c == wrap_symbol && c[i-1] != ' ' && c[i-1] != '\\'
        end_of_inline_element_index = i
        break
      end
    end
    return unless end_of_inline_element_index

    inline_ast = ast_type.new(inlines_parse(characters.shift(end_of_inline_element_index)))
    characters.shift(1)  # remove the last wrap symbol
    inline_ast
  end
end
