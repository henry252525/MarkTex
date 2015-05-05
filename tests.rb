require 'test/unit'

class MarkTex < Test::Unit::TestCase

  # ================== HELPERS =======================


  #TODO: Figure out if chomping is actually hiding some bugs
  #      (try to remove chomp and see if it breaks everything)

  def execute(test_input)
    `echo "#{test_input}" | ruby marktex.rb`.chomp
  end

  def read_file_contents path
    file = File.open path, 'rb'
    contents = file.read
    file.close
    contents
  end

  def execute_test_dir test_case_dir
    input_files = Dir.glob "test_cases/#{test_case_dir}/*.in"
    output_files = Dir.glob "test_cases/#{test_case_dir}/*.out"
    test_cases = input_files.zip output_files

    test_cases.each do |test_case|
      input_file_path, output_file_path = test_case
      input_data = read_file_contents(input_file_path).chomp
      output_data = read_file_contents(output_file_path).chomp

      assert_equal(
        output_data,
        execute(input_data)
      )
    end
  end

  # ================ TEST CASES ====================

  def test_unordered_list
    execute_test_dir 'unordered_list'
  end

  def test_headers
    execute_test_dir 'header'
  end

  def test_paragraph
    execute_test_dir 'paragraph'
  end

end
