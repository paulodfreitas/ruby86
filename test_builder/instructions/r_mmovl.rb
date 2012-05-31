class RMmovl < Instruction

  def initialize
    @icode = "4"
    @ifun = "0"

    @rB = @rA = rand 7
    while @rB == @rA do
      @rB = rand 7
    end

    @value = rand(1 << 31)
    @size = 0
  end

  def params_string builder
    @rA.to_s + @rB.to_s + "\n" + value_string
  end

  def value_string
    value_string = @value.to_s(16)
    value_string[6..7] + "\n" +
    value_string[4..5] + "\n" +
    value_string[2..3] + "\n" +
    value_string[0..1] + "\n"
  end

end