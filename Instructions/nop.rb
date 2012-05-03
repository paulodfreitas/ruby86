class Nop < Instruction
  def write_back
    processor.pc += 1
  end
end