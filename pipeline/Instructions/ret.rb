class Ret < Instruction
  def fetch(r)
    r = super(r)
    r[:ra] = 4 #todo magic number
    r[:rb] = 4
    return r
  end

  def op(va, vb, vc)
    vb + 4
  end

  def memory(r)
    r[:vm] = processor.memory[r[:va]]
    return r
  end
end