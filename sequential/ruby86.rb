require_relative 'instruction.rb'
require_relative 'memory.rb'

class RubY86
  attr_accessor :zf, :of, :sf, :pc, :registers, :memory
  attr_reader :pid

  def initialize
    @zf = @of = @sf = false
    @pid = 0
    @pc = 0
    @registers = [0]*8

    @memory = Memory.new 0x200000
  end

  #todo Make load_code more robust, to handle empty lines, spaces, more than one number on the same line etc
  #todo Handle case when file doesn't exist with more grace
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

      byte = line.scan(/\h+/).first.to_i(16)
      @memory.set_byte(i, byte)
      i+=1
    end
  end

  def step
    instruction = Instruction.factory self
    instruction.process
  end

  def encode_flags
    zf = @zf ? 1 : 0
    of = @of ? 1 : 0
    sf = @sf ? 1 : 0
    return (zf << 2) + (of << 1) + sf
  end

  def decode_flags value
    @zf = ((value & 0x4) >> 2) == 1
    @of = ((value & 0x2) >> 1) == 1
    @sf = (value & 0x1) == 1
  end

end