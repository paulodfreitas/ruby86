class RubY86


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

  def load_code
    i = 0
    code_lines = File.readlines "test/entry.out"
    code_lines.each do |line|
      # @var line String
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

  def run
    load_code

    #while true
    #  instruction = Instruction.factory
    #  instruction.process
    #end

  end

end

processor = RubY86.new.run