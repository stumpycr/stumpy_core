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
    
    def paste(canvas, x, y)
      (0...canvas.width).each do |cx|
        (0...canvas.height).each do |cy|
          current = safe_get(x + cx, y + cy)
          unless current.nil?
            self[x + cx, y + cy] = canvas[cx, cy].over(current)
          end
        end    
      end
    end
    
    def safe_get(x : Int32, y : Int32) : RGBA | Nil    
      if x < 0 || x >= width
        nil
      elsif y < 0 || y >= height
        nil
      else
        self[x, y]
      end
    end
    
    def safe_set(x : Int32, y : Int32, color : RGBA) : Bool
      if x < 0 || x >= width
        false
      elsif y < 0 || y >= height
        false
      else
        self[x, y] = color
        true
      end
    end
  end
end
