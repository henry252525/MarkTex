Dir[File.dirname(__FILE__) + '/ast/*.rb'].each {|file| require file }

input = 
"""# section
# # I am a section
#  I'm a section
 # I am not a section
## I am totally a SUBsection
### I am totally a SUBSUBsection
"""

@input_lines = input.split("\n")

def header_parse()
  [Subsubsection, Subsection, Section].each do |expr|
    child = expr.parse @input_lines[0]

    next if child.nil?

    @input_lines.shift
    return Header.new child
  end

  return nil
end


until @input_lines.empty? do
  prev_output = header_parse
  if prev_output.nil?
    puts "could not parse"
    @input_lines.shift
  else
    puts prev_output
  end
end
