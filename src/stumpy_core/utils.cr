module StumpyCore
  module Utils
    def self.scale_up(input, from)
      return input.to_u16 if from == 16
      (input.to_f / (2 ** from - 1) * (2 ** 16 - 1)).round.to_u16
    end

    def self.scale_from_to(input, from, to)
      (input.to_f / (2 ** from - 1) * (2 ** to - 1)).round
    end
  end
end
