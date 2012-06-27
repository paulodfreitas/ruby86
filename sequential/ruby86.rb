require_relative 'instruction.rb'
require_relative 'memory.rb'

class RubY86
  attr_reader :memory, :core1, :core2

  def halted
    @core1.halted and @core2.halted
  end

  def initialize
    @memory = Memory.new 0x200000
    @core1 = Core.new 0, @memory
    @core2 = Core.new 1, @memory
  end

  def reset
    @core1.reset
    @core2.reset
  end

  def step
    @core1.step if not @core1.halted
    @core2.step if not @core2.halted
  end
end