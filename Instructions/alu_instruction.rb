#todo Remember to handle things like sum of two big numbers being negative etc
#todo Remember about endianess. The processor must be little endian
class ALUInstruction < Instruction
  def self.has_ra
    true
  end

  def self.has_rb
    true
  end

  def execute r
    ve = op(r[:va], r[:vb])
    processor.of = false

    if self.is_a?(Add) or self.is_a?(Sub)
      s1  = (r[:va] & 0x80000000) == 0x80000000
      s2  = (r[:vb] & 0x80000000) == 0x80000000
      s1 = (not s1) if self.is_a?(Sub)

      b32 = (ve & 0x80000000) == 0x80000000
      b33 = (ve & 0x100000000) == 0x100000000

      processor.of = (s1 == s2) & (b32 ^ b33)
    end

    r[:ve] = ve % 0x100000000
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
  def op(valA, valB)
    r = valA + valB
  end
end

class Sub < ALUInstruction
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
  def self.has_ra
    false
  end

  def op(valA, valB)
    valB + 1
  end
end

class Dec < ALUInstruction
  def self.has_ra
    false
  end

  def op(valA, valB)
    valB - 1
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