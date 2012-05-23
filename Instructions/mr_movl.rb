class MRmovl < Instruction
  def self.has_ra
    true
  end

  def self.has_rb
    true
  end

  def self.has_val
    true
  end

  def fetch r
    r = super(r)
    r[:rb], r[:ra] = r[:ra], r[:rb]
    return r
  end

  def op(va, vb, vc)
    va + vc
  end

  def memory r
    r[:vm] = processor.memory[r[:ve]]
    return r
  end

  def write_back r
    processor.registers[r[:rb]] = r[:vm]
    return r
  end

  def get_registers_to_be_writen r
      return {r[:rb] => r[:vm]}
  end
end