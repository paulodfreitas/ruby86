class Halt < Instruction
  def execute r
    throw :halt
  end
end