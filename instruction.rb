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
    c = case processor.memory[processor.pc]
          when 0x00 then Nop
          when 0x10 then Halt
          when 0x60 then Add
          when 0x61 then Sub
          when 0x62 then And
          when 0x63 then Xorl
          when 0x64 then Inc
          when 0x65 then Dec
          when 0x66 then Not
          when 0x67 then Or
          else
            raise "Unhandled instruction: #{c.to_s}"    #todo: Remove this for something more elegant
        end
    c.new(processor)
  end
end