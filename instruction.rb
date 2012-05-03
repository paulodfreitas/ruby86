class Instruction

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

  def self.factory

  end

end