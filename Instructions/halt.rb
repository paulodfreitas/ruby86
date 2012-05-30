class Halt < Instruction
  def fetch r
    old_pc = r[:pred_pc]
    r = super r
    r[:pred_pc] = old_pc
    return r
  end

  def write_back r
    throw :halt
  end
end