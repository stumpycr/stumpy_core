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
      #StumpyPNG does not handle going out of bound well so we have to be very $

      #detect left side first
      min_x = (x < 0 ? x.abs : 0)
      max_x = canvas.width - (x + canvas.width >= width ? x + canvas.width - wi$
      min_y = (y < 0 ? y.abs : 0)
      max_y = canvas.height - (y + canvas.height >= height ? y + canvas.height $

      (min_x...max_x).each do |cx|
        (min_y...max_y).each do |cy|
          if canvas[cx, cy].a == UInt16::MAX
            self[x + cx, y + cy] = canvas[cx, cy]
          elsif canvas[cx, cy].a == UInt16::MIN
            #dont do anything, it's invisble
          else
            b_color = self[x + cx, y + cy]
            t_color = canvas[cx, cy]

        
            t_a = (t_color.a.to_f/UInt16::MAX)
            n_r = (t_color.r * t_a) + (b_color.r * (1.0 - t_a))
            n_g = (t_color.g * t_a) + (b_color.g * (1.0 - t_a))
            n_b = (t_color.b * t_a) + (b_color.b * (1.0 - t_a))

            self[x + cx, y + cy] = RGBA.new(n_r.to_u16, n_g.to_u16, n_b.to_u16,$
          end
        end    
      end
    end
  end
end
