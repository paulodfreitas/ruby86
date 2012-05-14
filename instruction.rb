class Instruction
  require_relative 'Instructions/alu_instruction'
  require_relative 'Instructions/call'
  require_relative 'Instructions/halt'
  require_relative 'Instructions/irmovl'
  require_relative 'Instructions/jmp'
  require_relative 'Instructions/mr_movl'
  require_relative 'Instructions/nop'
  require_relative 'Instructions/popl'
  require_relative 'Instructions/pushl'
  require_relative 'Instructions/ret'
  require_relative 'Instructions/rm_movl'
  require_relative 'Instructions/rr_movl'

  attr_accessor :processor
  protected :processor

  def self.has_ra
    false
  end

  def self.has_rb
    false
  end

  def self.has_val
    false
  end

  def initialize(processor)
    @processor = processor
  end

  def fetch
    r = {}
    r[:vp] = processor.pc + 1

    if self.class.has_ra or self.class.has_rb
      b = processor.memory[r[:vp]]
      r[:vp] += 1
      #mask in binary?
      r[:ra] = (b & 0xF0) >> 4
      r[:rb] = b & 0x0F

      if not self.class.has_ra and r[:ra] != 0x8 or not self.class.has_rb and r[:rb] != 0x8
        throw :invalid_instruction
      end
    end

    if self.class.has_val
      m = processor.memory
      vp = r[:vp]
      r[:vc] = ((m[vp + 3] * 256 + m[vp + 2]) * 256 + m[vp + 1]) * 256 + m[vp]
      r[:vp] += 4
    end

    return r
  end

  def decode r
    r[:va] = processor.registers[r[:ra]] if r[:ra] != nil
    r[:vb] = processor.registers[r[:rb]] if r[:rb] != nil

    return r
  end

  def execute r
    r[:ve] = op(r[:va], r[:vb], r[:vc])
    return r
  end

  def memory r
    return r
  end

  def write_back r
    if r[:rb] != nil and r[:rb] != 0x8
      processor.registers[r[:rb]] = r[:ve]
    end
    return r
  end

  def pc_update r
    processor.pc = r[:vp]
  end

#memory valA, valE, valP
#write_back rb, valE, esp, valM

  def process
    r = fetch
    r = decode r
    r = execute r
    r = memory r
    r = write_back r
    pc_update r
  end

  def self.factory processor
    c = case processor.memory[processor.pc]
          when 0x00 then Nop
          when 0x10 then Halt
          when 0x20 then RRmovl
          when 0x30 then IRmovl
          when 0x40 then RMmovl
          when 0x50 then MRmovl
          when 0x60 then Add
          when 0x61 then Sub
          when 0x62 then And
          when 0x63 then Xorl
          when 0x64 then Inc
          when 0x65 then Dec
          when 0x66 then Not
          when 0x67 then Or
          when 0x68 then Shl
          when 0x69 then Shr
          when 0x70 then Jmp
          when 0x71 then Jle
          when 0x72 then Jl
          when 0x73 then Je
          when 0x74 then Jne
          when 0x75 then Jge
          when 0x76 then Jg
          when 0x80 then Call
          when 0x90 then Ret
          when 0xa0 then Pushl
          when 0xb0 then Popl
          else
            raise "Unhandled instruction: #{c.to_s}"    #todo: Remove this for something more elegant
        end
    return c.new(processor)
  end
end

