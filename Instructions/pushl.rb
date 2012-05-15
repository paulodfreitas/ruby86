#todo Remeber to add pushf
class Pushl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = super.fetch
    r[:rb] = 4   #todo magic number
    return r
  end

  def op(va, vb, vc)
    vb - 4
  end

  def memory r
    processor.memory[r[:ve]] = r[:va]
    return r
  end
end