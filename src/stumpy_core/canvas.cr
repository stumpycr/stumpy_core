require "./rgba"

module StumpyCore
  class Canvas
    getter width : Int32
    getter height : Int32
    getter pixels : Slice(RGBA)

    def initialize(@width, @height, background = RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))
      @pixels = Slice.new(@width * @height, background)
    end

    def initialize(@width, @height, &block)
      @pixels = Slice.new(@width * @height, RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))

      (0...@width).each do |x|
        (0...@height).each do |y|
          color = yield({x, y})
          set(x, y, color)
        end
      end
    end

    def set(x, y, color)
      @pixels[x + @width * y] = color
    end

    def get(x, y)
      @pixels[x + @width * y]
    end

    def []=(x, y, color)
      set(x, y, color)
    end

    def [](x, y)
      get(x, y)
    end

    def wrapping_get(x : Int32, y : Int32) : RGBA
      self[x % @width, y % @height]
    end

    def wrapping_set(x : Int32, y : Int32, color : RGBA)
      self[x % @width, y % @height] = color
    end

    def safe_get(x : Int32, y : Int32) : RGBA | Nil
      includes_pixel?(x, y) ? self[x, y] : nil
    end

    def safe_set(x : Int32, y : Int32, color : RGBA) : Bool
      if includes_pixel?(x, y)
        self[x, y] = color
        true
      else
        false
      end
    end

    def includes_pixel?(x, y)
      0 <= x && x < @width && 0 <= y && y < @height
    end

    def each_column(&block)
      @height.times do |n|
        yield @pixels[n * @width, @width]
      end
    end

    def map!(&block)
      (0...@width).each do |x|
        (0...@height).each do |y|
          self[x, y] = yield self[x, y], x, y
        end
      end
    end

    def map(&block)
      canvas = Canvas.new(@width, @height)
      (0...@width).each do |x|
        (0...@height).each do |y|
          canvas[x, y] = yield self[x, y], x, y
        end
      end
      canvas
    end

    def ==(other)
      self.class == other.class &&
        @width == other.width &&
        @height == other.height &&
        @pixels == other.pixels
    end

    def paste(canvas : Canvas, x, y)
      (0...canvas.width).each do |cx|
        (0...canvas.height).each do |cy|
          current = safe_get(x + cx, y + cy)
          unless current.nil?
            self[x + cx, y + cy] = canvas[cx, cy].over(current)
          end
        end
      end
    end
  end
end
