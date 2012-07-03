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

        time = Time.now

        next_u = time.usec
        next_s = time.to_i
        sum = next_u + step
        next_u = sum % 10**6
        next_s = next_s + sum / 10**6

        while true
          time = Time.now
          now_s = time.to_i
          now_u = time.usec

          if now_s > next_s or now_s == next_s and now_u > next_u
            sum = next_u + step
            next_u = sum % 10**6
            next_s = next_s + sum / 10**6

            action.call
          end
        end
      end
    end

    @video.wait_for_kill
  end

  #def run
  #  i = 0
  #
  #  while true
  #    before = convert_time Time.now
  #    step
  #    i += 1
  #
  #    if @step * i > @video_step
  #      @video.update
  #    end
  #
  #
  #    while true
  #      now = convert_time Time.now
  #
  #      if now - before > @step
  #        break
  #      end
  #    end
  #  end
  #end

  #private
  #def convert_time time
  #  time.to_i * 1000000 + time.usec
  #end
end