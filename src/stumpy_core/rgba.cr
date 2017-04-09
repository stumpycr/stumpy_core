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
      raise "Invalid hex color: #{hex}" if hex.size != 7 || hex[0] != '#'

      r = hex[1,2].to_i(16)
      g = hex[3,2].to_i(16)
      b = hex[5,2].to_i(16)
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
  end
end
