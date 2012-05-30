class Halt < Instruction

  def initialize
    @icode = "1"
    @ifun= "0"
    @size = 1
  end

  def params_string builder
    ""
  end

end