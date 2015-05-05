require 'test/unit'

class MarkTex < Test::Unit::TestCase
  def execute(test_input)
    `echo "#{test_input}" | ruby marktex.rb`.chomp
  end

  def test_headers
    assert_equal execute('#Section'), '\section{Section}'
    assert_equal execute('# Section'), '\section{Section}'
    assert_equal execute('## Subsection'), '\subsection{Subsection}'
  end

  def test_paragraph
    assert_equal(
      "I am a paragraph. I am on the same paragraph",
      execute("I am a paragraph.\nI am on the same paragraph")
    )
    assert_equal(
      "I am a paragraph.\nI am on another paragraph",
      execute("I am a paragraph.\n\nI am on another paragraph")
    )
  end

  def read_file_contents path
    file = File.open path, 'rb'
    contents = file.read
    file.close
    contents
  end

  def test_unordered_list
    input_files = Dir.glob 'test_cases/unordered_list/*.in'
    output_files = Dir.glob 'test_cases/unordered_list/*.out'
    test_cases = input_files.zip output_files

    test_cases.each do |test_case|
      input_file_path, output_file_path = test_case
      input_data = read_file_contents input_file_path
      output_data = read_file_contents output_file_path

      assert_equal(
        output_data,
        execute(input_data)
      )
    end
  end



end
