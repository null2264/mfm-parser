# MfmParser

A simple parser for [Misskey Flavoured Markdown](https://github.com/misskey-dev/mfm.js/).

It only parses the MFM specific syntax of the form $[name.params content] and newlines. 
That means that it doesn't parse links, usernames, HTML, Markdown or Katex.

The Parser returns a tree, which looks like

    [
      %MfmParser.Text{
        props: %{
          text: "it's not chocolatine, it's "
        }
      },
      %MfmParser.MFM.Twitch{
        props: %{
          speed: "0.2s"
        },
        children: [
          %MfmParser.Text{
            props: %{
              text: "pain au chocolat"
            }
          }
        ]
      }
    ]

You can also convert the tree into HTML.

## Examples

    iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]")
    [
      %MfmParser.Node.MFM.Twitch{
        children: [%MfmParser.Node.Text{props: %{text: "🍮"}}],
        props: %{speed: "5s"}
      }
    ]
    iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]") |> MfmParser.to_html()                                    
    "<span style=\\"display: inline-block; animation: 5s ease 0s infinite normal none running mfm-twitch;\\">🍮</span><style>@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}</style>"

## Reading
### The Parser

A [parser](https://en.wikipedia.org/wiki/Parsing#Parser) takes in structured text and outputs a so called "tree". A tree is a data structure which can be more easily worked with. 

A parser typically consists of three parts
* a Reader
* a Lexer (aka Tokeniser)
* the Parser

A Reader typically has a `next` function which takes the next character out of the input and returns it. 
A `peek` function allows it to peek at the next character without changing the input. 
There's also some way of detecting if the eof (End Of File) is reached. 
Depending on the needs of the parser, it may be implemented to allow asking for the nth character instead of just the next. 

A Lexer uses the Reader. It also has a `peek` and `next` function, but instead of returning the next (or nth) character, it returns the next (or nth) token. 
E.g. if you have the MFM `$[spin some text]`, then `$[spin`, `some text`, and `]` can be considered three different tokens. 

The parser takes in the tokens and forms the tree. This is typically a data structure the programming language understands and can more easily work with. 

### The Encoder

Once we have a good data structure, we can process this and do things with it. 
E.g. an Encoder encodes the tree into a different format. 

### The code

The code can be found in the *lib* folder. It contains, among other things, the Reader, Lexer, Parse, and Encoder modules. 

The *test* folder contains the unit tests.

## License

    A parser/encoder for Misskey Flavoured Markdown.
    Copyright (C) 2022  Ilja

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
