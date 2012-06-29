require_relative 'sdl.rb'

class Video
  def initialize memory
    @lines = 300
    @columns = 300
    @begin = 0x10000
    @memory = memory
    SDL::init SDL::INIT_EVERYTHING
    @screen = SDL::Screen.open @columns, @lines, 32, SDL::SWSURFACE
  end

  def update
    pos = @begin

    @lines.times do |y|
      @columns.times do |x|
        from_memory = @memory[pos]
        r = (from_memory & 0xff0000) >> 16
        g = (from_memory & 0xff00) >> 8
        b = (from_memory & 0xff)
        #print "(#{r}, #{g}, #{b})\n"
        pixel = @screen.format.map_rgb(r,g,b)
        @screen.put_pixel x, y, pixel
        pos += 4
      end
    end

    @screen.flip
  end
end