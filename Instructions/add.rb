require_relative 'alu_instruction'

class Add < ALUInstruction
  def execute(valA, valB, regDest)
    puts 'Add executed'
    sum = valA + valB
    return sum, regDest
  end
end