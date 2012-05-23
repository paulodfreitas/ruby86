class Halt < Instruction
  def write_back r
    throw :halt
  end
end