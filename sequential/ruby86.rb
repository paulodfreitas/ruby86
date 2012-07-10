require_relative 'instruction.rb'
require_relative 'memory.rb'
require_relative 'core.rb'
require_relative 'video.rb'

class RubY86
  attr_reader :memory, :core1, :core2

  def halted
    @core1.halted and @core2.halted
  end

  def initialize
    @memory = Memory.new 0x200000
    @core1 = Core.new 0, @memory
    @core2 = Core.new 1, @memory
    @video = Video.new @memory
    @step = 1000
    @video_step = 10**6 / 60 #60fps
  end

  def reset
    @core1.reset
    @core2.reset
  end

  def step
    @core1.step if not @core1.halted
    @core2.step if not @core2.halted
  end

  def run
    [[@video_step, @video.method(:update)], [@step, method(:step)]].each do |params|
      Thread.new(params) do |params|
        step = params[0]
        action = params[1]

        while true
          #sleep(step/(10**6))
          action.call
        end
      end
    end

    @video.wait_for_kill
  end

  #def run
  #  while !halted
  #    step
  #  end
  #end

end