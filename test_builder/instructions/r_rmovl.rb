class RRmovl < Instruction

  def initialize
    @icode = "2"
    @ifun = "0"

    @rB = @rA = rand 7
    while @rB == @rA do
      @rB = rand 7
    end

    @size = 2
  end

  def params_string builder
    @rA.to_s + @rB.to_s + "\n"
  end

end