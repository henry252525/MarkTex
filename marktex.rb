Dir[File.dirname(__FILE__) + '/ast/*.rb'].each {|file| require file }

input_lines = $stdin.read.split("\n")

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
      return cls.new(match[1])
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
  children.push(Paragraph.new('')) if children.empty?

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
    end
    break if should_break
    data.push input.shift
  end

  return nil if data.empty?
  Paragraph.new data.join(' ')
end





until input_lines.empty? do
  prev_output = block_parse input_lines
  if prev_output.nil?
    puts "could not parse"
    input_lines.shift
  else
    puts prev_output
  end
end


