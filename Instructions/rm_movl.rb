class RMmovl < Instruction
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
    processor.memory[r[:ve]] = r[:va]
    return r
  end
end