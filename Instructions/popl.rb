#todo Remeber to add popl
class Popl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = {}
    r[:vp] = processor.pc + 1

    b = processor.memory[r[:vp]]
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4
    r[:rb] = 5

    return r
  end

  def op(va, vb, vc)
    vb + 4
  end

  def memory r
    r[:vm] =  processor.memory[r[:vb]]
    return r
  end

  def write_back r
    processor.registers[r[:rb]] = r[:ve]
    if r[:ra] == 8        # instruction is popf
      processor.decode_flags r[:vm]
    else
      processor.registers[r[:ra]] = r[:vm]
    end
    return r
  end
end