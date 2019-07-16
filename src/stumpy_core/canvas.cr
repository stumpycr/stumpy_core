require "./rgba"

module StumpyCore

  # A canvas is 2D array of `RGBA` pixels
  #
  # To create a canvas of size `400` x `200`
  #
  # ```
  # canvas = StumpyCore::Canvas.new(400, 200)
  # ```
  #
  # The default background color is transparent,
  # but it can be passed in as a parameter or as a block
  # that returns the color value for each `{x, y}` pair.
  #
  # ```
  # canvas2 = StumpyCore::Canvas.new(400, 200, RGBA::WHITE)
  # ```
  #
  # ```
  # canvas3 = StumpyCore::Canvas.new(256, 256) do |x, y|
  #   RGBA.from_rgb_n(x, y, 255, 8)
  # end
  # ```
  # ![image](https://github.com/stumpycr/stumpy_core/blob/feature/images/rainbow.png?raw=true)
  #
  # Because of the way pixels are stored in a `Slice`,
  # `Canvas`es are limited to `Int32::MAX = 2147483647` pixels in total,
  # e.g. a maximal size of 46340x46340 for a square image.
  class Canvas
    getter width : Int32
    getter height : Int32
    getter pixels : Slice(RGBA)

    def initialize(@width, @height, background = RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))
      size = @width.to_i64 * @height
      if size > Int32::MAX
        raise "The maximum size of a canvas is #{Int32::MAX} total pixels"
      end
      @pixels = Slice.new(size.to_i32, background)
    end

    def initialize(@width, @height, &block)
      size = @width.to_i64 * @height
      if size > Int32::MAX
        raise "The maximum size of a canvas is #{Int32::MAX} total pixels"
      end
      @pixels = Slice.new(size.to_i32, RGBA.new(0_u16, 0_u16, 0_u16, 0_u16))

      (0...@width).each do |x|
        (0...@height).each do |y|
          color = yield({x, y})
          set(x, y, color)
        end
      end
    end

    # Get the value of pixel `(x, y)`
    # without checking if `(x, y)` is a valid position.
    def get(x, y)
      @pixels[x + @width * y]
    end

    # Set the value of pixel `(x, y)` to `color`
    # without checking if `(x, y)` is a valid position.
    def set(x, y, color)
      @pixels[x + @width * y] = color
    end

    # Short form for `get`
    def [](x, y)
      get(x, y)
    end

    # Short form for `set`
    def []=(x, y, color)
      set(x, y, color)
    end

    # Same as `get`, but if `x` ore `y` are outside of the canvas,
    # wrap them over at the edges.
    # E.g. `wrapping_get(300, 250)` on a 200x200 canvas
    # returns the pixel at `(100, 50)`.
    def wrapping_get(x : Int32, y : Int32) : RGBA
      self[x % @width, y % @height]
    end

    # Same as `set`, but wrapping along the canvas edges.
    # See `wrapping_get` for an example.
    def wrapping_set(x : Int32, y : Int32, color : RGBA)
      self[x % @width, y % @height] = color
    end

    # Same as `get`,
    # but returns `nil` if `(x, y)` are outside of the canvas
    def safe_get(x : Int32, y : Int32) : RGBA | Nil
      includes_pixel?(x, y) ? self[x, y] : nil
    end

    # Same as `set`, but only sets the pixel,
    # if it is part of the canvas.
    # Returns `true` if the pixel was set successfully,
    # `false` if it was outside of the canvas.
    def safe_set(x : Int32, y : Int32, color : RGBA) : Bool
      if includes_pixel?(x, y)
        self[x, y] = color
        true
      else
        false
      end
    end

    # Check if pixel `(x, y)` is part of this canvas.
    def includes_pixel?(x, y)
      0 <= x && x < @width && 0 <= y && y < @height
    end


    # Iterate over each row of the canvas
    # (a `Slice(RGBA)` of size `@width`).
    # The main usecase for this is
    # writing code that encodes images
    # in some file format.
    def each_row(&block)
      @height.times do |n|
        yield @pixels[n * @width, @width]
      end
    end

    # Modify pixels by
    # applying a function `(color, x, y) -> new_color`
    # to each pixel of the current canvas,
    # e.g. to invert colors
    def map!(&block)
      (0...@width).each do |x|
        (0...@height).each do |y|
          self[x, y] = yield self[x, y], x, y
        end
      end
    end

    # Same as `map!`, but instead of mutating the current canvas,
    # a new one is created and returned
    def map(&block)
      canvas = Canvas.new(@width, @height)
      (0...@width).each do |x|
        (0...@height).each do |y|
          canvas[x, y] = yield self[x, y], x, y
        end
      end
      canvas
    end

    # Same as `map!` but passes along a fourth parameter
    # with the index in the `pixels` slice
    def map_with_index!(&block)
      (0...@height).each do |y|
        offset = @width * y
        (0...@width).each do |x|
          self[x, y] = yield self[x, y], x, y, offset + x
        end
      end
    end

    # Same as `map` but passes along a fourth parameter
    # with the index in the `pixels` slice
    def map_with_index(&block)
      canvas = Canvas.new(@width, @height)
      (0...@height).each do |y|
        offset = @width * y
        (0...@width).each do |x|
          canvas[x, y] = yield self[x, y], x, y, offset + x
        end
      end
      canvas
    end

    # Two canvases are considered equal
    # if they are of equal size
    # and all their pixels are equal
    def ==(other)
      self.class == other.class &&
        @width == other.width &&
        @height == other.height &&
        @pixels == other.pixels
    end

    # Past the contents of a second `Canvas`
    # into this one,
    # starting at position `(x, y)`.
    # The pixels are combined using the `RGBA#over` function.
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
