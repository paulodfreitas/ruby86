class Call < Instruction
  def self.has_val
    true
  end

  def fetch r
    r = super r
    r[:rb] = 4
    r[:pred_pc] = r[:vc]
    return r
  end

  def op(va, vb, vc)
    vb - 4
  end

  def memory r
    processor.memory[r[:ve]] = r[:vp]
    return r
  end
end