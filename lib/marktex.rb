require_relative 'ast/document'
require_relative 'parser'

input_lines = $stdin.read.split("\n")

parser = Parser.new
if ARGV.delete('-b')
  puts parser.document_parse(input_lines).body
else
  puts parser.document_parse(input_lines)
end
