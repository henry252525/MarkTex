Dir[File.dirname(__FILE__) + '/ast/*.rb'].each {|file| require file }

input_lines = $stdin.read.split("\n")

def document_parse(input)
  title = title_parse(input)

  blocks = []
  until input.empty? do
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

def title_parse(input)
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

def block_parse(input)
  child = header_parse(input) || unordered_list_parse(input) || paragraph_parse(input)
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

def header_parse(input)
  SECTION_PARSING_LIST.each do |cls, expression|
    match = expression.match input[0]
    if match
      input.shift
      return cls.new(Terminal.new(match[1]))
    end
  end

  return nil
end

UNORDERED_LIST_TOKENS = ['* ', '- ']
def unordered_list_parse(input)
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

def unordered_list_item_parse(input)
  children = []
  until input.empty?
    child = unordered_list_parse(input) || paragraph_parse(input)
    children.push(child) unless child.nil?
  end
  children.push(Paragraph.new(Terminal.new(''))) if children.empty?

  UnorderedListItem.new children
end

# TODO: Do not repeat unordered list tokens
FORBIDDEN_STRINGS = [
  '#',
  '- ',
  '* '
]
def paragraph_parse(input)
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

if ARGV.delete('-b')
  puts document_parse(input_lines).body
else
  puts document_parse(input_lines)
end
