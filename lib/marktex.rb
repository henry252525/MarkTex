require_relative 'ast/document'
require_relative 'parser'

input_lines = $stdin.read.split("\n")

if ARGV.delete('-b')
  puts Parser::document_parse(input_lines).body
else
  puts Parser::document_parse(input_lines)
end
