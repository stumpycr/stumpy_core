require "./spec_helper"

include StumpyCore

describe StumpyCore do
  describe Canvas do
    describe ".new" do
      it "throws an error if the size is to big" do
        size = 2**30
        expect_raises(Exception) do
          canvas = Canvas.new(size, size)
        end
      end
    end
  end

  describe RGBA do
    describe ".from_relative" do
      it "is reversible" do
        tuple = {0.2, 0.4, 0.6, 0.8}
        color = RGBA.from_relative(tuple)
        color.to_relative.should eq(tuple)
      end
    end

    describe ".from_hex" do
      it "handles shorthands" do
        a = RGBA.from_hex("#123")
        b = RGBA.from_hex("#112233")

        a.should eq(b)
      end

      it "handles colors w/ alpha" do
        a = RGBA.from_hex("#F123")
        b = RGBA.from_hex("#FF112233")

        a.should eq(b)
        b.should eq(RGBA.from_hex("#112233"))
      end
    end

    describe ".from_gray_n" do
      it "handles 1-bit values" do
        RGBA.from_gray_n(0, 1).should eq(RGBA.from_hex("#000"))
        RGBA.from_gray_n(1, 1).should eq(RGBA.from_hex("#fff"))
      end

      it "handles 8-bit values" do
        RGBA.from_gray_n(0, 8).should eq(RGBA.from_hex("#000"))
        RGBA.from_gray_n(255, 8).should eq(RGBA.from_hex("#fff"))

        v = 180
        color = RGBA.from_gray_n(v, 8)
        color.r.should eq(UInt16::MAX / 255 * v)
      end
    end

    describe ".from_rgb_n" do
      it "handles 1-bit values" do
        RGBA.from_rgb_n({0, 0, 0}, 1).should eq(RGBA.from_hex("#000"))
        RGBA.from_rgb_n({1, 0, 0}, 1).should eq(RGBA.from_hex("#f00"))
        RGBA.from_rgb_n({1, 1, 1}, 1).should eq(RGBA.from_hex("#fff"))
      end

      it "handles 8-bit values" do
        c = RGBA.from_hex("#abcdef")
        vs = c.to_rgb8
        RGBA.from_rgb_n(vs, 8).should eq(c)
      end
    end
  end
end
