class Call < Instruction

  def initialize
    @icode = "8"
    @ifun = "0"
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
