require_relative 'instruction.rb'
require_relative 'memory.rb'

class Core
  attr_accessor :zf, :of, :sf, :pc, :registers, :memory, :core_id
  attr_reader :halted

  def initialize core_id, memory
    @zf = @of = @sf = false
    @core_id = core_id
    @pc = core_id
    @registers = [0]*8

    @memory = memory
  end

  def reset
    @pc = 0
    @halted = false
  end

  def step
    instruction = Instruction.factory self, @memory

    catch (:halt) do
      @halted = true
      instruction.process
      @halted = false
    end
  end

  def encode_flags
    zf = @zf ? 0x8 : 0
    of = @of ? 0x4 : 0
    sf = @sf ? 0x2 : 0
    cid = @core_id
    return zf | of | sf | cid
  end

  def decode_flags value
    @zf = (value & 0x8) == 0x8
    @of = (value & 0x4) == 0x4
    @sf = (value & 0x2) == 0x2
    #The fact that core_id is not seted here is intentional since core_id is a constant.
  end
end