class Jmp < Instruction

  def initialize
    @icode = "7"
    @ifun = rand(7).to_s
    @size = 6
  end

  def params_string builder
    destination_string = builder.random_destination
    destination_string[6..7] + "\n" +
    destination_string[4..5] + "\n" +
    destination_string[2..3] + "\n" +
    destination_string[0..1] + "\n"
  end

end