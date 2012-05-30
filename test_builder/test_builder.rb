require_relative 'instruction.rb'

class TestBuilder

  attr_accessor :code_size, :valid_jumps, :instructions

  def initialize
    @code_size = 0
    @valid_jumps = Array.new(0)
    @instructions = Array.new
  end

  def random_i_code
    rand 12
  end

  def int_to_s_16_zerofill value, nr_to_fill
    value = value.to_s 16
    (nr_to_fill - value.size).times do
      value = "0"+value
    end

    value
  end


  def random_destination
    int_to_s_16_zerofill(@valid_jumps[rand @valid_jumps.size], 8)
  end

  def buildInstruction
    instruction_class = case random_i_code
      when 0x0 then Nop
      when 0x1 then Halt
      when 0x2 then RRmovl
      when 0x3 then IRmovl
      when 0x4 then RMmovl
      when 0x5 then MRmovl
      when 0x6 then Alu
      when 0x7 then Jmp
      when 0x8 then Call
      when 0x9 then Ret
      when 0xA then Push
      when 0xB then Pop
    end

    instruction = instruction_class.new
    @valid_jumps[@valid_jumps.size] = @code_size
    @code_size += instruction.size
    @instructions[@instructions.size] = instruction
  end

  def build nr_instructions
    nr_instructions.times do
      buildInstruction
    end
  end

  def printCode size
    build 10
    puts "@ 0000"
    @instructions.each do |instruction|
      puts instruction.to_s self
    end

    puts "@ "+ int_to_s_16_zerofill(@code_size, 4)
  end
end

TestBuilder.new.printCode 10


