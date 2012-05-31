class Call < Instruction
  def self.has_val
    true
  end

  def fetch
    r = super
    r[:rb] = 4
    return r
  end

  def op(va, vb, vc)
    vb - 4
  end

  def memory r
    processor.memory[r[:ve]] = r[:vp]
    return r
  end

  def pc_update r
    processor.pc = r[:vc]
  end
end