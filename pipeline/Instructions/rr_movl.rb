class RRmovl < Instruction
  def self.has_ra
    true
  end

  def self.has_rb
    true
  end

  def op(va, vb, vc)
    va
  end
end