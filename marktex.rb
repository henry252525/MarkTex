Dir[File.dirname(__FILE__) + '/ast/*.rb'].each {|file| require file }

@input_lines = $stdin.read.split("\n")

def block_parse()
  child = header_parse || paragraph_parse
  return nil if child.nil?
  Block.new child
end

def header_parse()
  [Subsubsection, Subsection, Section].each do |expr|
    child = expr.parse @input_lines[0]

    next if child.nil?

    @input_lines.shift
    return Header.new child
  end

  return nil
end

FORBIDDEN_STRINGS = [
  '#'
]
def paragraph_parse()
  data = []
  until @input_lines.empty? do
    if @input_lines.first.empty?
      @input_lines.shift
      break
    end
    should_break = false
    FORBIDDEN_STRINGS.each do |s|
      should_break = @input_lines.first.start_with? s
    end
    break if should_break
    data.push @input_lines.shift
  end

  return nil if data.empty?
  Paragraph.new data.join(' ')
end

until @input_lines.empty? do
  prev_output = block_parse
  if prev_output.nil?
    puts "could not parse"
    @input_lines.shift
  else
    puts prev_output
  end
end
