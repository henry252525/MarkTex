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
    assert_equal "I am a paragraph. I am on the same paragraph",
      execute("I am a paragraph.\nI am on the same paragraph")
    assert_equal "I am a paragraph.\nI am on another paragraph",
      execute("I am a paragraph.\n\nI am on another paragraph")
  end
end
