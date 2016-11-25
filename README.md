# stumpy_core

## Usage

This library is not very useful on its own
but there are a few other libraries
that allow creating a canvas from an image file
or saving one to an image file.

* <https://github.com/l3kn/stumpy_png>
* <https://github.com/l3kn/stumpy_gif>

```crystal
include StumpyCore

rainbow = Canvas.new(256, 256)
(0...255).each do |x|
  (0...255).each do |y|
    # RGBA.from_rgb_n(values, bit_depth) is an internal helper method
    # that creates an RGBA object from a rgb triplet with a given bit depth
    color = RGBA.from_rgb_n(x, y, 255, 8)
    rainbow[x, y] = color
  end
end

# It is also possible to provide a background color,
# the default is transparent black `RGBA.new(0, 0, 0, 0)`
white = Canvas.new(256, 256, RGBA.from_hex("#ffffff"))

# If the colors for all pixels are already known when creating the canvas,
# the block syntax can be used to simplify the code:

rainbow2 = Canvas.new(256, 256) { |x, y| RGBA.from_rgb_n(x, y, 255, 8) }

checkerboard = Canvas.new(256, 256) do |x, y|
  if ((x / 32) + (y / 32)).odd?
    RGBA.from_hex("#ffffff")
  else
    RGBA.from_hex("#000000")
  end
end
```

![rainbow image](images/rainbow.png)
![checkerboard image](images/checkerboard.png)

## Interface

* `StumpyCore::RGBA`, 16-bit rgba color
  * `rgba.r` red channel
  * `rgba.g` green channel
  * `rgba.b` blue channel
  * `rgba.a` alpha channel
  * `rgba.to_rgba8` returns a tuple of 4 8-bit values `{ r, g, b, a}`
  * `rgba.to_rgb8` returns a tuple of 3 8-bit values  `{ r, g, b }`
  * Helper functions to create colors from n-bit values:
    * `StumpyCore::RGBA.from_gray_n(grayscale_value, n)`
    * `StumpyCore::RGBA.from_graya_n(grayscale_value, alpha, n)`
    * `StumpyCore::RGBA.from_rgb_n(r, g, b, n)`
    * `StumpyCore::RGBA.from_rgba_n(r, g, b, alpha, n)`
    * All of the above (except `from_gray_n`) work with tuples/arrays, too
      (`StumpyCore::RGBA.from_rgba_n({r, g, b, alpha}, n)`
    * `StumpyCore::RGBA.from_hex(color)`, e.g. `color = "#ff0000"`

* `StumpyCore::Canvas`, two dimensional Array of RGBA value
  * `canvas.width`
  * `canvas.height`
  * `canvas[x, y] = color` to set a color, `x` and `y` need to be in range!
  * `canvas[x, y]` to get a color, `x` and `y` need to be in range!
  * `canvas.set(x, y, color)` same as `canvas[x, y] = color`
  * `canvas.get(x, y)` same as `canvas[x, y]`
  * `canvas.safe_set(x, y, color)` returns true if setting the color was successful
  * `canvas.safe_get(x, y)` returns `nil` if `x` or `y` are invalid
  * `canvas.wrapping_set(x, y, color)` `set` combined with modulo, to ensure `x` and `y` are in range
  * `canvas.wrapping_get(x, y)` `get` combined with modulo, to ensure `x` and `y` are in range

## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
| [<img src="https://avatars.githubusercontent.com/u/2060269?v=3" width="100px;"/><br /><sub>Leon</sub>](https://github.com/l3kn)<br />[💻](https://github.com/l3kn/stumpy_core/commits?author=l3kn) | [<img src="https://avatars.githubusercontent.com/u/1298501?v=3" width="100px;"/><br /><sub>Ian Rash</sub>](https://github.com/redcodefinal)<br />[💻](https://github.com/l3kn/stumpy_core/commits?author=redcodefinal) |
| :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!
