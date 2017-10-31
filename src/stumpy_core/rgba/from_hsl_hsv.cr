module StumpyCore
  struct RGBA
    # Helper method for hsl conversion
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

    # Create a RGBA struct
    # from [HLS](https://en.wikipedia.org/wiki/HSL_and_HSV) values
    # and an alpha component.
    # 
    # Range of the values:
    # * __h__ue = 0..360
    # * __s__aturaiton = 0..100
    # * __l__ightness = 0..100
    # * __a__lpha = 0.0..1.0 
    def self.from_hsla(h, s, l, alpha)
      h /= 360.0
      s /= 100.0
      l /= 100.0

      if s == 0.0
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

    # Same as `from_hsla(h, s, l, a)`, but from a tuple `{h, s, l, a}`.
    def self.from_hsla(values)
      h, s, l, a = values
      from_hsla(h, s, l, a)
    end

    # Same as `from_hsla(h, s, l, a)`, but without the alpha component.
    # (`a` defaults to `1.0`)
    def self.from_hsl(h, s, l)
      from_hsla(h, s, l, 1.0)
    end

    # Same as `from_hsl(h, s, l)`, but from a tuple `{h, s, l}`.
    def self.from_hsl(values)
      h, s, l = values
      from_hsla(h, s, l, 1.0)
    end

    # Create a RGBA struct
    # from [HLV](https://en.wikipedia.org/wiki/HSL_and_HSV) values
    # and an alpha component.
    # 
    # Range of the values:
    # * __h__ue = 0..360
    # * __s__aturaiton = 0..100
    # * __v__value = 0..100
    # * __a__lpha = 0.0..1.0 
    def self.from_hsva(h, s, v, alpha)
      h /= 360.0
      s /= 100.0
      v /= 100.0

      if s == 0.0
        from_relative(v, v, v, alpha)
      else
        h *= 6.0
        h = 0.0 if h >= 6
        i = h.floor
        i1 = v * (1 - s)
        i2 = v * (1 - s * (h - i))
        i3 = v * (1 - s * (1 - (h - i)))

        case i
        when 0
          from_relative(v, i3, i1, alpha)
        when 1
          from_relative(i2, v, i1, alpha)
        when 2
          from_relative(i1, v, i3, alpha)
        when 3
          from_relative(i1, i2, v, alpha)
        when 4
          from_relative(i3, i1, v, alpha)
        # i == 5 is the only other option
        # Use `else` instead of `when 5` so the return value can't be `nil`
        else
          from_relative(v, i1, i2, alpha)
        end
      end
    end

    # Same as `from_hsva(h, s, v, a)`, but from a tuple `{h, s, v, a}`.
    def self.from_hsva(values)
      h, s, v, a = values
      from_hsva(h, s, v, a)
    end

    # Same as `from_hsva(h, s, v, a)`, but without the alpha component.
    # (`a` defaults to `1.0`)
    def self.from_hsv(h, s, v)
      from_hsva(h, s, v, 1.0)
    end

    # Same as `from_hsl(h, s, l)`, but from a tuple `{h, s, l}`.
    def self.from_hsv(values)
      h, s, l = values
      from_hsva(h, s, l, 1.0)
    end
  end
end
