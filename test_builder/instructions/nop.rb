class Nop < Instruction

  def initialize
    @icode = "0"
    @ifun = "0"
    @size = 1
  end

  def params_string builder
    ""
  end

end