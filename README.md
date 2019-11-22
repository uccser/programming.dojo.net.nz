# Programming Dojo Website

This is the source code for [programming.dojo.net.nz](https://programming.dojo.net.nz).

## Motivation

This website was designed as part of my university study with Dr. Tim Bell in the course "COSC433 Computer Science Education" in 2010. There is [a report](pages/welcome/Programming%20Dojo%20Report.pdf) which covers the initial development of this site.

At the time I was concerned about the isolated approach to teaching programming languages in education. In particular, because teachers often lack the formal education, students often receive a biased impression about language strengths and weaknesses.

This website and the resources it makes available, are designed to encourage an open mind when it comes to programming languages, both for students and teachers. Even though teachers may only be comfortable with one language, students should understand this does not make it intrinsically better than any other language.

## Installation

Ensure you have a working Ruby interpreter.

Install all dependencies:

```
$ bundle install
```

## Usage

Run the web application server:

```
$ rake
```

The site can be accessed locally using the default endpoint: [https://localhost:9292](https://localhost:9292).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## See Also

- [async](https://github.com/socketry/async) — An example of how to use this template.

## License

Released under the MIT license.

Copyright, 2019, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
