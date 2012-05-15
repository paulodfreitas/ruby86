require_relative 'instruction.rb'
require_relative 'memory.rb'

class RubY86
  attr_accessor :zf, :of, :sf, :pc, :registers, :memory
  attr_reader :pid

  def initialize
    @zf = @of = @sf = 0
    @pid = 0
    @pc = 0
    @registers = [0]*8

    @memory = Memory.new 0x200000
  end

  def set_flags val
    @of = (val & 0x80000000) ^ (val & 0x100000000)
    @sf = (val & 0x80000000) == 1
    @zf = val == 0
  end

  #todo Make load_code more robust, to handle empty lines, spaces, more than one number on the same line etc
  #todo Handle case when file doesn't existe with more grace
  def load_code filename
    i = 0
    code_lines = File.readlines filename
    code_lines.each do |line|
      line.strip!

      if line.start_with? "#"
        next
      end

      if line.start_with? "@"
        i = line.scan(/\h+/).first.to_i(16)
        next
      end

      @memory[i] = line.scan(/\h+/).first.to_i(16)
      i+=1
    end
  end

  def step
    instruction = Instruction.factory self
    instruction.process
  end

  #def run filename
  #  load_code filename
  #
  #  kind_of_halt = catch (:halt) do
  #    while true
  #      step
  #    end
  #  end
  #
  #  case kind_of_halt
  #    when :invalid_instruction
  #      puts "Invalid instruction executed"
  #  end
  #end


end