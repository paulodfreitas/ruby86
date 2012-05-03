require_relative '../instruction.rb'

class Halt < Instruction
  def execute
    throw :halt
  end
end