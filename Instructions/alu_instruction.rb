class ALUInstruction < Instruction
  def fetch
    b0 = processor.memory[processor.pc]
    b1 = processor.memory[processor.pc + 1]
    return b0, b1
  end

  def decode(src, dest)
    srcVal = processor.registers[src]
    destVal = processor.registers[dest]
    return srcVal, destVal, dest
  end

  def memory(val, reg_dest)
    return val, reg_dest
  end


  def write_back(val, reg_dest)
    processor.registers[reg_dest] = val
    processor.pc += 2
  end
end