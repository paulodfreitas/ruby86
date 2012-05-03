class Halt < Instruction
  def execute
    throw :halt
  end
end