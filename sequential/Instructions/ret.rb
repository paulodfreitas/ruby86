class Ret < Instruction
  def fetch
    r = super
    r[:ra] = 4
    r[:rb] = 4
    return r
  end

  def op(va, vb, vc)
    vb + 4
  end

  def memory r
    r[:vm] = processor.memory[r[:va]]
    return r
  end

  def pc_update r
    processor.pc = r[:vm]
  end
end