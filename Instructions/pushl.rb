#todo Remeber to add pushf
class Pushl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = {}
    r[:vp] = processor.pc + 1

    b = processor.memory[r[:vp]]
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4


    r[:rb] = 4   #todo magic number
    return r
  end

  def decode r
    if r[:ra] == 8 # instruction is pushf
      r[:va] = processor.encode_flags
    else
      r[:va] = processor.registers[r[:ra]] if r[:ra] != nil
    end

    r[:vb] = processor.registers[r[:rb]] if r[:rb] != nil
    r
  end

  def op(va, vb, vc)
    vb - 4
  end

  def memory r
    processor.memory[r[:ve]] = r[:va]
    return r
  end
end