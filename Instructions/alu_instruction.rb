#todo Remember about endianess. The processor must be little endian
class ALUInstruction < Instruction
  def self.binary
    true
  end

  #todo Add validation so that invalid registers are not used
  def fetch
    b = processor.memory[processor.pc + 1]
    b0 = b & 0x11110000
    b1 = b & 0x00001111
    return b0, b1
  end

  def decode(src, dest)
    srcVal = processor.registers[src]
    destVal = dest != 8 ? processor.registers[dest] : nil
    return srcVal, destVal, dest
  end

  def execute(valA, valB, dest)
    r = op(valA, valB)
    processor.set_flags r
    r = r % 0x100000000
    print "Result is: ", r, "\n"
    return r, dest
  end

  def memory(val, reg_dest)
    return val, reg_dest
  end

  def write_back(val, reg_dest)
    processor.registers[reg_dest] = val
    processor.pc += 2
  end
end

class Add < ALUInstruction
  def op(valA, valB)
    valA + valB
  end
end

class Sub < ALUInstruction
  def op(valA, valB)
    valA - valB
  end
end

class And < ALUInstruction
  def op(valA, valB)
    valA and valB
  end
end

class Xorl < ALUInstruction
  def op(valA, valB)
    valA ^ valB
  end
end

class Inc < ALUInstruction
  def self.binary
    false
  end

  def op(valA, valB)
    valA + 1
  end
end

class Dec < ALUInstruction
  def self.binary
    false
  end

  def op(valA, valB)
    valA - 1
  end
end

class Not < ALUInstruction
  def self.binary
    false
  end

  def op(valA, valB)
    not valA
  end
end

class Or < ALUInstruction
  def op(valA, valB)
    valA or valB
  end
end

class Shl < ALUInstruction
  def op(valA, valB)
    valB << valA
  end
end

class Shr < ALUInstruction
  def op(valA, valB)
    valB >> valA
  end
end