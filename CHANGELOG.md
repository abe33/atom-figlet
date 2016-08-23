<a name="v0.5.4"></a>
# v0.5.4 (2016-08-23)

## :bug: Bug Fixes

- Fix error due to change in API in latest Atom version ([7b65f4bb](https://github.com/abe33/atom-figlet/commit/7b65f4bb58d61e66b6acb0d09929f3639dce9f4c))

<a name="v0.5.3"></a>
# v0.5.3 (2015-11-19)

## :sparkles: Features

- Implement supporting prefix with several spaces and comment chars ([ec59ccb0](https://github.com/abe33/atom-figlet/commit/ec59ccb0c4123981f6f08b2ecfea33c6d544fedd))

<a name="v0.5.2"></a>
# v0.5.2 (2015-10-12)

## :bug: Bug Fixes

- Remove oniguruma from dependencies ([4bf6e47e](https://github.com/abe33/atom-figlet/commit/4bf6e47e1669610555eaa468972e5e9119c1b318), [#7](https://github.com/abe33/atom-figlet/issues/7))

<a name="v0.5.1"></a>
# v0.5.1 (2015-10-07)

## :bug: Bug Fixes

- Fix potential error if the grammar doesn't have a comment form ([36edf3ec](https://github.com/abe33/atom-figlet/commit/36edf3ec1d81530d3edd43c8291d814249ff7250))

<a name="v0.5.0"></a>
# v0.5.0 (2015-10-07)

## :sparkles: Features

- Implement preserving single comment before the expression to convert ([71252b8c](https://github.com/abe33/atom-figlet/commit/71252b8c91a038e092935f847a73de1246ce4aff), [#3](https://github.com/abe33/atom-figlet/issues/3))
- Implement stripping trailing whitespaces and empty lines ([0ce1cf37](https://github.com/abe33/atom-figlet/commit/0ce1cf375611298393c0119a033aa0e6ff8b8384), [#6](https://github.com/abe33/atom-figlet/issues/6))

## :bug: Bug Fixes

- Fix indentation not preserved on conversion ([e5587d71](https://github.com/abe33/atom-figlet/commit/e5587d71814b4342402c847fc29697f364eea241), [#5](https://github.com/abe33/atom-figlet/issues/5))

<a name="v0.4.0"></a>
# v0.4.0 (2015-04-28)

## :sparkles: Features

- Implement a figlet:convert-last command ([805d209c](https://github.com/abe33/atom-figlet/commit/805d209cf00dda7a5f4db6823121131d661e1941), [#1](https://github.com/abe33/atom-figlet/issues/1))  <br>It’ll convert the selection without prompting for the font. It’ll just
  reuse either the settings value or the last picked font.
- Add an atom-panel wrapper on the figlet font list ([50442063](https://github.com/abe33/atom-figlet/commit/504420630b369fb9e24dfabb34f8363675a8a097))

## :bug: Bug Fixes

- Fix invalid scope since use of custom elements ([146ac59c](https://github.com/abe33/atom-figlet/commit/146ac59c2d6f5b48a1be03bf8ecdbfc716f33b7a))

<a name="v0.3.1"></a>
# v0.3.1 (2015-01-23)

## :bug: Bug Fixes

- Fix deprecations ([48471981](https://github.com/abe33/atom-figlet/commit/484719814180b6559f7a8aa1a745d51875f6eaf9))

<a name="v0.3.0"></a>
# v0.3.0 (2015-01-23)

## :bug: Bug Fixes

- Fix deprecations ([5b5d674f](https://github.com/abe33/atom-figlet/commit/5b5d674fe52321c1bbebb42f16000e679efb07fc))


<a name="v0.1.0"></a>
# v0.1.0 (2014-06-06)

## :sparkles: Features

- Add test to verify the panel removal on confirmation ([f7fd502f](https://github.com/abe33/atom-figlet/commit/f7fd502f13e11634a523a454e834fefaa74ed278))
- Implement ascii conversion ([4ca260dd](https://github.com/abe33/atom-figlet/commit/4ca260dd55d2552c068fdd0919ac6ece7949f3c3))
- Add test for default selection ([1c25ed33](https://github.com/abe33/atom-figlet/commit/1c25ed33f9fb8c8122dc7e542d70208221d53dcc))
- Implement fonts loading and default selection ([c88b3fd4](https://github.com/abe33/atom-figlet/commit/c88b3fd4507f6fb8046b55acb7d8747d7821d27a))
- Add test case for empty selection ([3ea789f2](https://github.com/abe33/atom-figlet/commit/3ea789f2d5c581047518d2533244eb5e8bdf242b))
- Add font list view attachment specs ([f10e1201](https://github.com/abe33/atom-figlet/commit/f10e1201063a6af040b585032e28151d1b9327b2))
- Add travis build status ([55136470](https://github.com/abe33/atom-figlet/commit/5513647085c97954588e15ca5bff1b83451fcddf))
