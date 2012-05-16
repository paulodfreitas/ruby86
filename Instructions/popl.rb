#todo Remeber to add popl
class Popl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = {}
    r[:vp] = processor.pc + 1

    b = processor.memory.get_byte(r[:vp])
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4
    @is_popf = b == 0x0 or b == 0x88
    r[:rb] = 4


    puts self.to_s(r)
    return r
  end

  def op(va, vb, vc)
    vb + 4
  end

  def memory r
    if @is_popf
      r[:vm] =  processor.memory.get_byte(r[:vb])
    else
      r[:vm] =  processor.memory[r[:vb]]
    end

    return r
  end

  def write_back r
    processor.registers[r[:rb]] = r[:ve]
    if @is_popf        # instruction is popf
      processor.decode_flags r[:vm]
    else
      processor.registers[r[:ra]] = r[:vm]
    end
    return r
  end
end