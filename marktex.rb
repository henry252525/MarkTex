def section
  /^#\s*(.*)$/
end

def subsection
  /^##\s*(.*)$/
end

def header
  orr(subsection, section)
end

def orr(*expressions)
  # assume expression is a regexp
  lambda do |input|
    expressions.each do |e|
      match = e.match input
      return match[1] unless match.nil?
    end
    return nil
  end
end


input = 
"""# section
# # I am a section
#  I'm a section
 # I am not a section
## I am totally a SUBsection"""

input_lines = input.split("\n")

def header_parse(input_lines)
  match_data = header.call input_lines[0]

  if match_data.nil?
    return [nil, input_lines]
  end

  input_lines.shift
  return [match_data, input_lines]
end


prev_output = [true, input_lines]
until prev_output[0].nil? || prev_output[1].empty? do
  prev_output = header_parse(prev_output[1])
  puts prev_output[0]
end
