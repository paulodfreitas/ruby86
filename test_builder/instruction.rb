class Instruction
  Dir.glob(File.dirname(__FILE__) + '/instructions/*') {|file| require file}

  attr_accessor :icode, :ifun, :size

  def initialize

  end

  def to_s builder
    @icode.to_s + @ifun.to_s + "\n" + params_string(builder)
  end

  def params_string builder

  end

end