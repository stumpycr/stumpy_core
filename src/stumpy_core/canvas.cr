require "./rgba"

module StumpyCore
  class Canvas
    getter width : Int32
    getter height : Int32
    getter pixels : Slice(RGBA)

    def initialize(@width, @height, background = RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))
      @pixels = Slice.new(@width * @height, background)
    end

    def []=(x, y, color)
      @pixels[x + @width * y] = color
    end

    def [](x, y)
      @pixels[x + @width * y]
    end

    def includes_pixel?(x, y)
      0 <= x && x < @width && 0 <= y && y < @height
    end

    def each_column(&block)
      @height.times do |n|
        yield @pixels[n * @width, @width]
      end
    end

    def ==(other)
      self.class == other.class &&
        @width == other.width &&
        @height == other.height &&
        @pixels == other.pixels
    end
  end
end
