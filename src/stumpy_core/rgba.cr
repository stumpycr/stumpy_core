require "./utils"

module StumpyCore
  struct RGBA
    getter r : UInt16
    getter g : UInt16
    getter b : UInt16
    getter a : UInt16

    def initialize(@r, @g, @b, @a = UInt16::MAX)
    end

    def initialize(gray : UInt16, @a = UInt16::MAX)
      @r = @g = @b = gray
    end

    def multiply(other : RGBA) : RGBA
      r0, g0, b0, a0 = self.to_relative
      r1, g1, b1, a1 = other.to_relative

      RGBA.from_relative(
        r0 * r1,
        g0 * g1,
        b0 * b1,
        a0 * a1
      )
    end

    def over(other : RGBA) : RGBA
      if self.a == UInt16::MAX
        self
      elsif self.a == 0
        other
      else
        # See: https://en.wikipedia.org/wiki/Alpha_compositing
        alpha_a = self.a.to_f / UInt16::MAX
        alpha_b = other.a.to_f / UInt16::MAX

        # Some precalculated factors
        pre_1 = alpha_b * (1 - alpha_a)
        alpha_0 = alpha_a + pre_1

        new_r = ((self.r * alpha_a) + (other.r * pre_1)) / alpha_0
        new_g = ((self.g * alpha_a) + (other.g * pre_1)) / alpha_0
        new_b = ((self.b * alpha_a) + (other.b * pre_1)) / alpha_0
        new_a = alpha_0 * UInt16::MAX

        RGBA.new(new_r.to_u16, new_g.to_u16, new_b.to_u16, new_a.to_u16)
      end
    end

    def self.from_gray_n(value, n)
      gray = Utils.scale_up(value, n)
      RGBA.new(gray, gray, gray, UInt16::MAX)
    end

    def self.from_graya_n(values, n)
      g, a = values
      from_graya_n(g, a, n)
    end

    def self.from_graya_n(g, a, n)
      gray = Utils.scale_up(g, n)
      alpha = Utils.scale_up(a, n)
      RGBA.new(gray, gray, gray, alpha)
    end


    def self.from_rgb_n(values, n)
      r, g, b = values
      from_rgb_n(r, g, b, n)
    end

    def self.from_rgb_n(r, g, b, n)
      red = Utils.scale_up(r, n)
      green = Utils.scale_up(g, n)
      blue = Utils.scale_up(b, n)
      RGBA.new(red, green, blue, UInt16::MAX)
    end

    def self.from_rgba_n(values, n)
      r, g, b, a = values
      from_rgba_n(r, g, b, a, n)
    end

    def self.from_rgba_n(r, g, b, a, n)
      red = Utils.scale_up(r, n)
      green = Utils.scale_up(g, n)
      blue = Utils.scale_up(b, n)
      alpha = Utils.scale_up(a, n)
      RGBA.new(red, green, blue, alpha)
    end

    def self.from_hex(hex : String)
      raise "Invalid hex color: #{hex}" if (hex.size != 7 && hex.size != 4) || hex[0] != '#'
      if hex.size == 4
        r = hex[1].to_i(16) * 17
        g = hex[2].to_i(16) * 17
        b = hex[3].to_i(16) * 17
      else
        r = hex[1,2].to_i(16)
        g = hex[3,2].to_i(16)
        b = hex[5,2].to_i(16)
      end
      from_rgb_n(r, g, b, 8)
    end

    def self.from_rgb8(r, g, b)
      from_rgb_n(r, g, b, 8)
    end

    def to_rgb8
      {
        Utils.scale_from_to(r, 16, 8).to_u8,
        Utils.scale_from_to(g, 16, 8).to_u8,
        Utils.scale_from_to(b, 16, 8).to_u8,
      }
    end

    def self.from_rgba8(r, g, b, a)
      from_rgba_n(r, g, b, a, 8)
    end

    def to_rgb
      to_rgb8
    end

    def self.from_rgb(r, g, b)
      self.from_rgb8(r, g, b)
    end

    def to_rgba
      {
        Utils.scale_from_to(r, 16, 8).to_u8,
        Utils.scale_from_to(g, 16, 8).to_u8,
        Utils.scale_from_to(b, 16, 8).to_u8,
        Utils.scale_from_to(a, 16, 8).to_u8,
      }
    end

    def self.from_relative(r, g, b, a)
      RGBA.new(
        (r * UInt16::MAX).to_u16,
        (g * UInt16::MAX).to_u16,
        (b * UInt16::MAX).to_u16,
        (a * UInt16::MAX).to_u16
      )
    end

    def to_relative
      {
        r.to_f / UInt16::MAX,
        g.to_f / UInt16::MAX,
        b.to_f / UInt16::MAX,
        a.to_f / UInt16::MAX,
      }
    end

    private def self.get_hsl_hue(a, b, c)
      c += 1.0 if c < 0
      c -= 1.0 if c > 1

      if c < 1.0/6.0
        a + (b - a) * 6.0 * c
      elsif c < 1.0/2.0
        b
      elsif c < 2.0/3.0
        a + (b - a) * (2.0/3.0 - c) * 6.0
      else
        a
      end
    end

    def self.from_hsla(h, s, l, alpha)
      h /= 360.0
      s /= 100.0
      l /= 100.0

      if s == 0
        from_relative(l, l, l, alpha)
      else
        b = l < 0.5 ? l * (1.0 + s) : l + s - l * s
        a = 2.0 * l - b

        from_relative(
          get_hsl_hue(a, b, h + 1.0/3.0),
          get_hsl_hue(a, b, h),
          get_hsl_hue(a, b, h - 1.0/3.0),
          alpha
        )
      end
    end

    def self.from_hsla(hsla)
      h, s, l, a = hsla
      from_hsla(h, s, l, a)
    end

    def self.from_hsl(h, s, l)
      from_hsla(h, s, l, 1.0)
    end

    def self.from_hsl(hsl)
      h, s, l = hsl
      from_hsla(h, s, l, 1.0)
    end
  end
end
