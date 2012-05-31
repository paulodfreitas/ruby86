class Jmp < Instruction
  def self.has_val
    true
  end

  def execute r
    r[:cc] = op
    return r
  end

  def pc_update r
    processor.pc = r[:cc] ? r[:vc] : r[:vp]
  end

  def op
    true
  end
end

class Jle < Jmp
  def op
    (processor.sf ^ processor.of) or processor.zf
  end
end

class Jne < Jmp
  def op
    not processor.zf
  end
end

class Jl < Jmp
  def op
    processor.sf ^ processor.of
  end
end

class Jge < Jmp
  def op
    not (processor.sf ^ processor.of)
  end
end

class Jg < Jmp
  def op
    not (processor.sf ^ processor.of) and not processor.zf
  end
end

class Je <  Jmp
  def op
    processor.zf
  end
end
