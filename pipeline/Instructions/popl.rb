class Popl < Instruction
  def self.has_ra
    true
  end

  def fetch r
    r[:vp] = r[:pred_pc] + 1

    b = processor.memory.get_byte(r[:vp])
    r[:vp] += 1
    r[:ra] = (b & 0xf0) >> 4
    @is_popf = b == 0x0 or b == 0x88
    r[:rb] = 4
    r[:pred_pc] = r[:vp]

    return r
  end

  def is_popf
    return @is_popf
  end

  def op(va, vb, vc)
    (vb + (@is_popf ? 1 : 4)) % 0x100000000
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
    if @is_popf
      processor.decode_flags r[:vm]
    else
      processor.registers[r[:ra]] = r[:vm]
    end
    return r
  end

  def get_registers_to_be_writen r
      if @is_popf
        return {r[:rb] => r[:ve]}
      else
        return {r[:rb] => r[:ve], r[:ra] => r[:vm]}
      end

  end
end