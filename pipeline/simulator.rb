require_relative 'ruby86.rb'

class Simulator
  def initialize
    @processor = RubY86.new
    Instruction.reset self
  end

  def main
    puts "*** Y86 Simulator ***"
    catch (:exit) do
      print 'y86% '
      while true
        c = $stdin.getc
        case c
          when 'h' then print_help
          when 'r' then reset
          when 'd'
            a = gets
            dump a.to_i(16)
          when 'e' then exit
          when 'l'
            filename = gets
            filename.strip!
            load_file filename
          when 'j'
            a = gets
            jmp a.to_i(16)
          when 's' then step
          when 'x' then execute
          when 'p' then print_registers
          else
            next
        end
        print 'y86% '
      end
    end
  end

  def print_help
    puts "
r          : reset
d [address]: dump memory region
e          : exit
l filename : load assembly file
j  address : jump to address
s          : step
x          : execute instructions or until halt
p          : print register"
  end

  def reset
    Instruction.reset self
  end

  def dump addr
    10.times do |i|
      print (addr + i).to_s(16), ': 0x', @processor.memory.get_byte(addr + i).to_s(16)
      print "\n"
    end
  end

  def exit
    throw :exit
  end

  def load_file filename
    catch (:error) do
      @processor.load_code filename rescue puts "Unable to open file"
    end
  end

  def jmp addr
    @processor.pc = addr
  end

  def step
    catch (:end) do
      error_message = catch (:halt) do
        @processor.step
        throw :end
      end

      if error_message != nil
        print "ERROR: ", error_message, "\n"
      else
        puts "halted"
      end
    end
  end

  def execute
    error_message = catch (:halt) do
      while true
        @processor.step
      end
    end

    if error_message != nil
      print "ERROR: ", error_message, "\n"
    else
      puts "halted"
    end
  end

  def print_registers
    regs = %w(eax ecx edx ebx esp ebp esi edi)

    regs.each_with_index do |reg, i|
      v = @processor.registers[i]
      neg = false
      if v >= 0x80000000
        neg = true
        v = (v ^ 0xffffffff) + 1
      end
      print reg, ' = ', neg ? '-' : '', '0x', v.to_s(16), "\n"
    end

    print 'OF = ', @processor.of, "\n"
    print 'ZF = ', @processor.zf, "\n"
    print 'SF = ', @processor.sf, "\n"
  end
end

Simulator.new.main