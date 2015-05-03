require 'test/unit'

class MarkTex < Test::Unit::TestCase
  def execute(test_input)
    `echo "#{test_input}" | ruby marktex.rb`.chomp
  end

  def test_headers
    assert_equal execute('#Section'), '\section{Section}'
    assert_equal execute('# Section'), '\section{Section}'
    assert_equal execute('## Subsection'), '\subsection{Subsection}'
    assert_equal execute('Not a section'), 'could not parse'
    assert_equal execute(' # Not a section'), 'could not parse'
  end
end
