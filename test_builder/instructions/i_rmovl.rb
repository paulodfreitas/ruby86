class IRmovl < Instruction

  def initialize
    @icode = "3"
    @ifun = "0"

    @rB = rand 7
    @value = rand(1 << 31)
    @size = 6
  end

  def params_string builder
    "8" + @rB.to_s + "\n" + value_string
  end

  def value_string
    value_string = @value.to_s(16)
    value_string[6..7] + "\n" +
    value_string[4..5] + "\n" +
    value_string[2..3] + "\n" +
    value_string[0..1] + "\n"
  end

end