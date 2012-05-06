class Ret < Instruction
  def fetch
    r = super.fetch
    r[:ra] = 5
    r[:rb] = 5
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