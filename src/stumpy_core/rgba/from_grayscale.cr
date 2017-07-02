module StumpyCore
  struct RGBA
    # Create a `RGBA` struct from a n-bit grayscale value
    def self.from_gray_n(value, n)
      gray = Utils.scale_up(value, n)
      RGBA.new(gray, gray, gray, UInt16::MAX)
    end

    # Create a `RGBA` struct from a tuple of n-bit grayscale + alpha values
    def self.from_graya_n(values, n)
      g, a = values
      from_graya_n(g, a, n)
    end

    # Create a `RGBA` struct from n-bit grayscale + alpha values
    def self.from_graya_n(g, a, n)
      gray = Utils.scale_up(g, n)
      alpha = Utils.scale_up(a, n)
      RGBA.new(gray, gray, gray, alpha)
    end
  end
end
