class Halt < Instruction
  def execute
    throw :halt
  end

  def write_back
    processor.pc += 1
  end
end