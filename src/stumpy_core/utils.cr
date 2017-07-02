module StumpyCore
  module Utils
    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to 16 bits.
    def self.scale_up(input, from)
      return input.to_u16 if from == 16
      (input.to_f / (2 ** from - 1) * (2 ** 16 - 1)).round.to_u16
    end

    # Helper method,
    # scale a value `input`
    # from `from` bits resolution
    # to `to` bits resolution.
    def self.scale_from_to(input, from, to)
      (input.to_f / (2 ** from - 1) * (2 ** to - 1)).round
    end
  end
end
