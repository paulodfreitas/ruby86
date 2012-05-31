class Memory < Array
  def initialize size
    @size = size
  end

  alias old_set []=

  def set_byte(i, byte)
    old_set(i, byte)
  end

  def get_byte(i)
    at(i).to_i
  end

  def []=(i, val)
    old_set(i,     val & 0xff)
    old_set(i + 1, (val >> 8) & 0xff)
    old_set(i + 2, (val >> 16) & 0xff)
    old_set(i + 3, (val >> 24) & 0xff)
  end

  def [](index)
    l1 = at(index)
    l2 = at(index + 1)
    l3 = at(index + 2)
    l4 = at(index + 3)
    v = (((((l4.to_i << 8) + l3.to_i) << 8) + l2.to_i) << 8) + l1.to_i
    return v
  end
end