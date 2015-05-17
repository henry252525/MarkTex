class MathInline

  def initialize(raw_math)
    @raw_math = raw_math
  end

  def to_s
    "$#{@raw_math}$"
  end

end
