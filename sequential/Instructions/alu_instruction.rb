class ALUInstruction < Instruction
  def self.has_ra
    true
  end

  def self.has_rb
    true
  end

  def handle_overflow r
    false
  end

  def execute r
    r[:ve] = op(r[:va], r[:vb])

    processor.of = handle_overflow r

    r[:ve] = r[:ve] % 0x100000000
    processor.sf = (r[:ve] & 0x80000000) == 0x80000000
    processor.zf = r[:ve] == 0
    return r
  end

  def write_back r
    processor.registers[r[:rb]] = r[:ve]
    return r
  end
end

class Add < ALUInstruction
  def handle_overflow r
    s1  = (r[:va] & 0x80000000) == 0x80000000
    s2  = (r[:vb] & 0x80000000) == 0x80000000

    b32 = (r[:ve] & 0x80000000) == 0x80000000
    b33 = (r[:ve] & 0x100000000) == 0x100000000

    return (s1 == s2) & (b32 ^ b33)
  end

  def op(valA, valB)
    r = valA + valB
  end
end

class Sub < ALUInstruction
  def handle_overflow r
    s1  = (r[:va] & 0x80000000) == 0x80000000
    s2  = (r[:vb] & 0x80000000) == 0x00000000

    b32 = (r[:ve] & 0x80000000) == 0x80000000
    b33 = (r[:ve] & 0x100000000) == 0x100000000

    return (s1 == s2) & (b32 ^ b33)
  end

  def op(valA, valB)
    valB + (valA ^ (-1)) + 1
  end
end

class And < ALUInstruction
  def op(valA, valB)
    valA & valB
  end
end

class Xorl < ALUInstruction
  def op(valA, valB)
    valA ^ valB
  end
end

class Inc < ALUInstruction
  def handle_overflow r
    return r[:ve] == 0x10000000
  end

  def self.has_ra
    false
  end

  def op(valA, valB)
    valB + 1
  end
end

class Dec < ALUInstruction
  def handle_overflow r
    return r[:ve] == 0x17fffffff
  end

  def self.has_ra
    false
  end

  def op(valA, valB)
    valB + 0xffffffff
  end
end

class Not < ALUInstruction
  def self.has_ra
    false
  end

  def op(valA, valB)
    valB ^ -1
  end
end

class Or < ALUInstruction
  def op(valA, valB)
    valA || valB
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