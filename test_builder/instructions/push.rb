class Push < Instruction

  def initialize
    @icode = "A"
    @ifun = "0"
    @rB = rand 8
    @size = 2
  end

  def params_string builder
    @rB.to_s + "8\n"
  end
end