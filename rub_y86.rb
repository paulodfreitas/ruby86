require_relative 'instruction.rb'

class RubY86
  attr_accessor :zf, :of, :sf, :pc, :registers, :memory
  attr_reader :pid

  def initialize
    @zf = @of = @sf = 0
    @pid = 0
    @pc = 0
    @registers = [0]*8

    @memory  = []
    def @memory.[](index)
      self.at(index) ? self.at(index) : 0
    end
  end

  #todo Make load_code more robust, to handle empty lines, spaces, numbers on the same line etc
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

  def run filename
    load_code filename

    catch (:halt) do
      while true
        instruction = Instruction.factory self
        instruction.process
      end
    end
  end


end

processor = RubY86.new.run "test/test.out"