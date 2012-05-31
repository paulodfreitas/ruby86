class IRmovl < Instruction

  def initialize
    @icode = "3"
    @ifun = "0"

    @rB = rand 7
    @value = rand(1 << 21)
    @size = 6
  end

  def params_string builder
    "8" + @rB.to_s + "\n" + value_string
  end

  def int_to_s_16_zerofill value, nr_to_fill
    value = value.to_s 16
    (nr_to_fill - value.size).times do
      value = "0"+value
    end

    value
  end

  def value_string
    value_string = int_to_s_16_zerofill(@value, 8)
    value_string[6..7] + "\n" +
    value_string[4..5] + "\n" +
    value_string[2..3] + "\n" +
    value_string[0..1] + "\n"
  end

end