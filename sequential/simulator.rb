require_relative 'ruby86.rb'

class Simulator
  def initialize
    @machine = RubY86.new
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
    @cores.each do |core|
      core.pc = 0
    end
  end

  def dump addr
    10.times do |i|
      print (addr + i).to_s(16), ': 0x', @machine.memory.get_byte(addr + i).to_s(16)
      print "\n"
    end
  end

  def exit
    throw :exit
  end

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

      byte = line.scan(/\h+/).first.to_i(16)
      @machine.memory.set_byte(i, byte)
      i+=1
    end
  end

  def load_file filename
    catch (:error) do
      load_code filename rescue puts "Unable to open file"
    end
  end

  #todo: Must take in consideration which core it refers to
  #def jmp addr
  #  #@processor.pc = addr
  #end

  def step
    error = catch (:error) do
      @machine.step
    end

    if error != nil
      print "ERROR: ", error_message, "\n"
    end

    if @machine.halted
      print "halted\n"
    end
  end

  def execute
    unless @machine.halted
      @machine.step
    end
  end

  def run
    @machine.run
  end

  def print_registers
    regs = %w(eax ecx edx ebx esp ebp esi edi)

    cores = [@machine.core1, @machine.core2]

    cores.each_with_index do |core, i|
      print "From core #{i}\n"

      regs.each_with_index do |reg, i|
        v = core.registers[i]
        neg = false
        if v >= 0x80000000
          neg = true
          v = (v ^ 0xffffffff) + 1
        end
        print reg, ' = ', neg ? '-' : '', '0x', v.to_s(16), "\n"
      end

      print 'OF = ', core.of, "\n"
      print 'ZF = ', core.zf, "\n"
      print 'SF = ', core.sf, "\n"
    end
  end
end

Simulator.new.run