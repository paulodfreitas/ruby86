class Instruction
  Dir.glob(File.dirname(__FILE__) + '/Instructions/*') {|file| require file}

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

  def self.reset processor
    @@fin = {instruction: Nop.new(processor), pred_pc: 0}
    @@din = {instruction: Nop.new(processor)}
    @@ein = {instruction: Nop.new(processor)}
    @@min = {instruction: Nop.new(processor)}
    @@win = {instruction: Nop.new(processor)}
    @@halted = false
  end

  def initialize(processor)
    @processor = processor
  end

  def fetch(r)
    r[:vp] = r[:pred_pc] + 1

    if self.class.has_ra or self.class.has_rb
      b = processor.memory.get_byte(r[:vp])
      r[:vp] += 1
      r[:ra] = (b & 0xf0) >> 4
      r[:rb] = b & 0x0f

      if not self.class.has_ra and r[:ra] != 0x8 or not self.class.has_rb and r[:rb] != 0x8
        throw :halt, "invalid register usage"
      end
    end

    if self.class.has_val
      r[:vc] = processor.memory[r[:vp]]
      r[:vp] += 4
    end

    r[:pred_pc] = r[:vp]

    return r
  end

  def decode(r)
    r[:va] = processor.registers[r[:ra]] if r[:ra] != nil
    r[:vb] = processor.registers[r[:rb]] if r[:rb] != nil

    return r
  end

  def execute(r)
    r[:ve] = op(r[:va], r[:vb], r[:vc])
    return r
  end

  def op(va, vb, vc)
    return nil
  end

  def memory(r)
    return r
  end

  def write_back(r)
    if r[:rb] != nil and r[:rb] != 0x8
      processor.registers[r[:rb]] = r[:ve]
    end
    return r
  end

  def get_registers_to_be_writen r
    if r[:rb] != nil and r[:rb] != 0x8
      return {r[:rb] => r[:ve]}
    end

    return {}
  end
  #
  #def pc_update r
  #  processor.pc = r[:vp]
  #end

  def self.process processor
    @@fin = {instruction: self.nextInstruction(processor, @@fin[:pred_pc]), pred_pc: @@fin[:pred_pc]}
    fout = @@fin[:instruction].fetch @@fin
    dout = @@din[:instruction].decode @@din
    eout = @@ein[:instruction].execute @@ein
    mout = @@min[:instruction].memory @@min
    wout = @@win[:instruction].write_back @@win

    regs_e = @@ein[:instruction].get_registers_to_be_writen eout
    regs_m = @@min[:instruction].get_registers_to_be_writen mout
    regs_w = @@win[:instruction].get_registers_to_be_writen wout


    @@halted = eout[:instruction].is_a? Halt
    stall_decode = @@halted
    mispredicted = false

    #forwarding
    {:ra => :va,:rb => :vb}.each do |reg_symbol, val_symbol|
      reg = dout[reg_symbol]
      if reg != nil
        [regs_w, regs_m, regs_e].each do |regs|
          if  regs[reg] != nil
            dout[val_symbol] = regs[reg]
          elsif regs.has_key?(reg)
            stall_decode = true
          end
        end
      end
    end

    #if fout[:instruction].is_a? Call or fout[:instruction].is_a? Jmp
    #  fout[:pred_pc] = fout[:vc]
    #end

    if eout[:instruction].is_a? Ret
      stall_decode = true
    end

    if mout[:instruction].is_a? Ret
      mispredicted = true
      fout[:pred_pc] = mout[:vm]
    end

    if eout[:instruction].is_a? Jmp and not eout[:cc]
      mispredicted = true
      fout[:pred_pc] = eout[:vp]
    end

    normal = (not mispredicted) and (not stall_decode)

    if normal
      @@din = fout
      @@ein = dout
    end

    if stall_decode
      @@ein = {instruction: Nop.new(processor)}
    else
      @@fin = {pred_pc: fout[:pred_pc]}
    end

    if mispredicted
      @@din = {instruction: Nop.new(processor)}
      @@ein = {instruction: Nop.new(processor)}
    end

    @@min = eout
    @@win = mout

    puts wout[:instruction].to_s(wout)
  end

  def self.nextInstruction(processor, pred_pc)
    icode = processor.memory.get_byte(pred_pc)
    c = case icode
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
            throw :halt, "invalid instruction: #{icode.to_s(16)}"
        end
    return c.new(processor)
  end


  def to_s r
    regs = ['eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi', 'NO-REG']
    print self.class.to_s
    if self.class.has_ra
      print ' %', regs[r[:ra]]
    end

    if self.class.has_rb
      print ', %', regs[r[:rb]]
    end

    if self.class.has_val
      print ', $', r[:vc].to_s(16)
    end
  end
end

