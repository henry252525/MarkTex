require 'parser'
require 'ast/document'

def read_file_contents path
  file = File.open path, 'rb'
  contents = file.read
  file.close
  contents
end

#TODO: Figure out if chomping is actually hiding some bugs
#      (try to remove chomp and see if it breaks everything)

def execute_body(test_input)
  Parser::document_parse(test_input.split(/\n/)).body.chomp
end

describe Parser do

  test_folders = Dir.entries('test_cases').select {|f| !File.directory? f}

  test_folders.each do |category|
    context category do
      input_files = Dir.glob "test_cases/#{category}/*.in"
      output_files = Dir.glob "test_cases/#{category}/*.out"
      test_cases = input_files.zip output_files

      test_cases.each do |test_case|
        input_file_path, output_file_path = test_case
        input_data = read_file_contents(input_file_path).chomp
        output_data = read_file_contents(output_file_path).chomp

        filename = File.basename input_file_path, '.in'
        it filename do
          expect(execute_body input_data).to eql(output_data)
        end
      end
    end
  end
end
