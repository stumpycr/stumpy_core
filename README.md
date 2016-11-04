# stumpy_core
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors)
[![All Contributors](https://img.shields.io/badge/all_contributors-0-orange.svg?style=flat-square)](#contributors)

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

* `StumpyCore::Canvas`, two dimensional Array of RGBA value
  * `canvas.width`
  * `canvas.height`
  * `canvas[x, y] = color` to set a color, `x` and `y` need to be in range!
  * `canvas[x, y]` to get a color, "
  * `canvas.set(x, y, color)` same as `canvas[x, y] = color`
  * `canvas.get(x, y)` same as `canvas[x, y]`
  * `canvas.safe_get(x, y)` returns `nil` if `x` or `y` are invalid
  * `canvas.safe_set(x, y, color)` returns true if setting the color was successful
  * `canvas.wrapping_set(x, y)` `set` combined with modulo, to ensure `x` and `y` are in range
  * `canvas.wrapping_get(x, y)` `get` combined with modulo, to ensure `x` and `y` are in range

## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
| [<img src="https://avatars.githubusercontent.com/u/2060269?v=3" width="100px;"/><br /><sub>Leon</sub>](https://github.com/l3kn)<br />[💻](https://github.com/l3kn/stumpy_core/commits?author=l3kn) |
| :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!