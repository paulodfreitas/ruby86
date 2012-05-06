class MRmovl < Instruction
  def self.has_ra
    true
  end

  def self.has_rb
    true
  end

  def self.has_val
    true
  end

  def op(va, vb, vc)
    vb + vc
  end

  def memory r
    r[:vm] = processor.memory[r[:ve]]
    return r
  end

  def write_back r
    processor.registers[r[:ra]] = r[:vm]
    return vp
  end
end