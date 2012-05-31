class Nop < Instruction
  def execute r
    return r
  end

  def write_back r
    return r
  end
end