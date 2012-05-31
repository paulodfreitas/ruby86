#todo Remeber to add pushf
class Pushl < Instruction
  def self.has_ra
    true
  end

  def fetch r
    r[:vp] = r[:pred_pc] + 1

    b = processor.memory.get_byte(r[:vp])
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4

    @is_pushf = b == 0x00 or b == 0x88
    r[:rb] = 4   #todo magic number

    r[:pred_pc] = r[:vp]
    return r
  end

  def decode r
    if not @is_pushf
      r[:va] = processor.registers[r[:ra]]
    end

    r[:vb] = processor.registers[r[:rb]]
    return r
  end

  def op(va, vb, vc)
    vb - (@is_pushf? 1 : 4)
  end

  def is_pushf
    return @is_pushf
  end

  def memory r
    if @is_pushf
      processor.memory.set_byte(r[:ve], processor.encode_flags)
    else
      processor.memory[r[:ve]] = r[:va]
    end

    return r
  end
end