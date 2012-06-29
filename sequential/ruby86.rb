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
    @video_step = @step * 100
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
    i = 0

    while true
      before = convert_time Time.now
      step
      i += 1

      if @step * i > @video_step
        @video.update
      end


      while true
        now = convert_time Time.now

        if now - before > @step
          break
        end
      end
    end
  end

  private
  def convert_time time
    time.to_i * 1000000 + time.usec
  end
end