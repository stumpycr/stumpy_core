module StumpyCore
  struct RGBA
    # Create a `RGBA` struct from a hex color string.
    #
    # Formats:
    # * "#rgb"
    # * "#rrggbb"
    # * "#argb"
    # * "#aarrggbb"
    def self.from_hex(hex : String)
      if hex.size == 0 || hex[0] != '#'
        raise "Invalid hex color: #{hex}"
      end

      case hex.size
      when 4
        r = hex[1].to_i(16)
        g = hex[2].to_i(16)
        b = hex[3].to_i(16)
        from_rgb_n(r, g, b, 4)
      when 5
        a = hex[1].to_i(16)
        r = hex[2].to_i(16)
        g = hex[3].to_i(16)
        b = hex[4].to_i(16)
        from_rgba_n(r, g, b, a, 4)
      when 7
        r = hex[1,2].to_i(16)
        g = hex[3,2].to_i(16)
        b = hex[5,2].to_i(16)
        from_rgb_n(r, g, b, 8)
      when 9
        a = hex[1,2].to_i(16)
        r = hex[3,2].to_i(16)
        g = hex[5,2].to_i(16)
        b = hex[7,2].to_i(16)
        from_rgba_n(r, g, b, a, 8)
      else
        raise "Invalid hex color: #{hex}"
      end
    end
  end
end
