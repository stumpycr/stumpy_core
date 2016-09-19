# stumpy_core

## Interface

* `StumpyCore::RGBA`, 16-bit rgba color
  * `rgba.r` red channel
  * `rgba.g` green channel
  * `rgba.b` blue channel
  * `rgba.a` alpha channel
  * `rgba.to_rgba8` returns a tuple of 4 8-bit values `{ r, g, b, a}`
  * `rgba.to_rgb8` returns a tuple of 3 8-bit values  `{ r, g, b }`
  * Helper functions to create colors from n-bit values:
    * `StumpyPNG::RGBA.from_gray_n(grayscale_value, n)`
    * `StumpyPNG::RGBA.from_graya_n(grayscale_value, alpha, n)`
    * `StumpyPNG::RGBA.from_rgb_n(r, g, b, n)`
    * `StumpyPNG::RGBA.from_rgba_n(r, g, b, alpha, n)`
    * All of the above (except `from_gray_n`) work with tuples/arrays, too
      (`StumpyPNG::RGBA.from_rgba_n({r, g, b, alpha}, n)`

* `StumpyCore::Canvas`, two dimensional Array of RGBA value
  * `canvas.width`
  * `canvas.height`
  * `canvas[x, y]=`
  * `canvas[x, y]`
