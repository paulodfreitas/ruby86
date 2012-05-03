class Instruction
  require_relative 'Instructions/halt'
  require_relative 'Instructions/nop'
  require_relative 'Instructions/alu_instruction'

  attr_accessor :processor
  protected :processor

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
      when 0x60
        Add.new(processor)
      else
        raise "Unhandled instruction: #{b}"    #todo: Remove this for something more elegant
    end
  end
end