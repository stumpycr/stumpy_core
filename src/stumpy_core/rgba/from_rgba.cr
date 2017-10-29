module StumpyCore
  struct RGBA
    # Create a `RGBA` struct from a tuple of n-bit red, green and blue values
    def self.from_rgb_n(values, n)
      r, g, b = values
      from_rgb_n(r, g, b, n)
    end

    # Create a `RGBA` struct from n-bit red, green and blue values
    def self.from_rgb_n(r, g, b, n)
      red = Utils.scale_up(r, n)
      green = Utils.scale_up(g, n)
      blue = Utils.scale_up(b, n)
      RGBA.new(red, green, blue, UInt16::MAX)
    end

    # Create a `RGBA` struct from a tuple of n-bit
    # red, green, blue and alpha values
    def self.from_rgba_n(values, n)
      r, g, b, a = values
      from_rgba_n(r, g, b, a, n)
    end

    # Create a `RGBA` struct from n-bit red, green, blue and alpha values
    def self.from_rgba_n(r, g, b, a, n)
      red = Utils.scale_up(r, n)
      green = Utils.scale_up(g, n)
      blue = Utils.scale_up(b, n)
      alpha = Utils.scale_up(a, n)
      RGBA.new(red, green, blue, alpha)
    end

    # Shorthand for `from_rgb_n(values, 8)`
    def self.from_rgb8(values)
      r, g, b = values
      self.from_rgb8(r, g, b)
    end

    # Shorthand for `from_rgb_n(r, g, b, 8)`
    def self.from_rgb8(r, g, b)
      from_rgb_n(r, g, b, 8)
    end
    
    # Shorthand for `from_rgb_n(r, g, b, 8)`
    def self.from_rgb(r, g, b)
      from_rgb_n(r, g, b, 8)
    end
    
    # Shorthand for `from_rgb_n(values, 8)`
    def self.from_rgb(values)
      r, g, b = values
      from_rgb_n(r, g, b, 8)
    end

    # Create a 8-bit `{r, g, b}` tuple,
    # the alpha component is just omitted.
    def to_rgb8
      {
        Utils.scale_from_to(r, 16, 8).to_u8,
        Utils.scale_from_to(g, 16, 8).to_u8,
        Utils.scale_from_to(b, 16, 8).to_u8,
      }
    end

    # Shorthand for `from_rgba_n(values, 8)`
    def self.from_rgba8(values)
      r, g, b, a = values
      self.from_rgba8(r, g, b, a)
    end
    
    # Shorthand for `from_rgba_n(r, g, b, a, 8)`
    def self.from_rgba8(r, g, b, a)
      from_rgba_n(r, g, b, a, 8)
    end

    # Shorthand for `from_rgba_n(values, 8)`
    def self.from_rgba(values)
      r, g, b, a = values
      self.from_rgba8(r, g, b, a)
    end
    
    # Shorthand for `from_rgba_n(r, g, b, a, 8)`
    def self.from_rgba(r, g, b, a)
      from_rgba_n(r, g, b, a, 8)
    end
    
    # Create a 8-bit `{r, g, b, a}` tuple.
    def to_rgba
      {
        Utils.scale_from_to(r, 16, 8).to_u8,
        Utils.scale_from_to(g, 16, 8).to_u8,
        Utils.scale_from_to(b, 16, 8).to_u8,
        Utils.scale_from_to(a, 16, 8).to_u8,
      }
    end
  end
end
