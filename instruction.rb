class Instruction
  require_relative 'Instructions/halt.rb'
  require_relative 'Instructions/nop.rb'

  def initialize(processor)
    @processor = processor
  end

  def fetch

  end

  def decode

  end

  def execute

  end

  def memory

  end

  def write_back

  end

  def process
    r = fetch
    r = decode   *r
    r = execute  *r
    r = memory   *r
    write_back   *r
  end

  def self.factory processor
    b = processor.memory[processor.pc]
    processor.pc += 1
    case b
      when 0
        Nop.new(processor)
      when 0x10
        Halt.new(processor)
      else
        raise "Unhandled instruction: #{b}"    #todo: Remove this for something more elegant
    end
  end
end