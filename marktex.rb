Dir[File.dirname(__FILE__) + '/ast/*.rb'].each {|file| require file }

input_lines = $stdin.read.split("\n")

def block_parse(input)
  child = header_parse(input) || paragraph_parse(input)
  return nil if child.nil?
  Block.new child
end

def header_parse(input)
  [Subsubsection, Subsection, Section].each do |expr|
    child = expr.parse input[0]

    next if child.nil?

    input.shift
    return Header.new child
  end

  return nil
end

FORBIDDEN_STRINGS = [
  '#'
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
