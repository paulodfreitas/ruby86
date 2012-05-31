class Alu < Instruction

  def initialize
    @icode = "6"
    @ifun = rand(9).to_s
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