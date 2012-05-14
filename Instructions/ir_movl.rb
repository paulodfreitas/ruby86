class IRmovl < Instruction
  def self.has_rb
    true
  end

  def self.has_val
    true
  end

  def op(va, vb, vc)
    vc
  end
end