require_relative 'ruby86.rb'

class Simulator
  def initialize
    @processor = RubY86.new
  end

  def main
    catch (:exit) do
      while true
        print 'y86% '
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
          when 'x'
            n = gets
            execute n.to_i(16)
          when 'p' then print_registers
          when 'm' then print_last_memory_access
          when 'u'
            a = gets
            unassemble a.to_i(16)
        end
      end
    end
  end

  def print_help
    #todo: put the text here
  end

  def reset
    @processor.pc = 0
  end

  def dump addr
    10.times do |i|
      print (addr + i).to_s(16), ': ', @processor.memory[addr + i]
      print "\n"
    end
  end

  def exit
    throw :exit
  end

  def load_file filename
    @processor.load_code filename
  end

  def jmp addr
    @processor.pc = addr
  end

  def step
    @processor.step
  end

  #todo: Not sure if the parameter is the number of instructions or the instruction per si
  def execute n
    kind_of_halt = catch (:halt) do
      n.times do
        @processor.step
      end
    end

    case kind_of_halt
      when :invalid_instruction
        puts "Invalid instruction executed"
    end
  end

  #todo: I'm not sure whether the registers have these numbers
  def print_registers
    regs = ['eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'esp', 'ebp']

    regs.each_with_index do |reg, i|
      print reg, '=', @processor.registers[i].to_s(16), "\n"
    end
  end

  #todo: Not sure if I need to implement this and if I do, what it should do
  def print_last_memory_access

  end

  #todo: Not sure if I need to implement this and if I do, what it should do
  def unassemble addr

  end
end

Simulator.new.main