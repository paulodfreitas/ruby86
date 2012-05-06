#todo Remeber to add popl
class Popl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = super.fetch
    r[:rb] = 5
    return r
  end

  def op(va, vb, vc)
    vb + 4
  end

  def memory r
    r[:vm] =  processor.memory[r[:va]]
    return r
  end

  def write_back r
    processor.registers[r[:rb]] = r[:ve]
    processor.registers[r[:ra]] = r[:vm]
    return r
  end
end