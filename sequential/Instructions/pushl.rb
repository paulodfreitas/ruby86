#todo Remeber to add pushf
class Pushl < Instruction
  def self.has_ra
    true
  end

  def fetch
    r = {}
    r[:vp] = processor.pc + 1

    b = processor.memory.get_byte(r[:vp])
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4

    @is_pushf = b == 0x0 or b == 0x88
    r[:rb] = 4   #todo magic number
    puts self.to_s(r)
    return r
  end

  def decode r
    if @is_pushf # instruction is pushf
      r[:va] = processor.encode_flags
    else
      r[:va] = processor.registers[r[:ra]]
    end

    r[:vb] = processor.registers[r[:rb]]
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