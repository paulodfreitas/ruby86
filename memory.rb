class Memory < Array
  def initialize size
    @size = size
  end

  alias old_set []=

  def []=(i, val)
    old_set(i,     val & 0x000000ff)
    old_set(i + 1, val & 0x0000ff00)
    old_set(i + 2, val & 0x00ff0000)
    old_set(i + 3, val & 0xff000000)
  end

  def [](index)
    at(index) ? at(index) : 0
  end
end