defmodule MfmParser do
  @moduledoc """
  `MfmParser` is a parser for [Misskey Flavoured Markdown](https://mk.nixnet.social/mfm-cheat-sheet). 

  It can parse MFM and return a tree. It can also turn a tree into HTML. 

  It only works for the MFM specific tags of the form $[name.opts content]. 

  Other parts of MFM (html, Markdown and [KaTeX](https://katex.org/)) are out of scope here. 

  ## Examples

      iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]")
      {:ok,
        [
          %{
            content: [%{content: "🍮", type: "text"}],
            name: "twitch.speed=5s", 
            type: "mfm"
          }
        ]
      }

      iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]") |> MfmParser.Converter.to_html()                                    
      "<span style=\"display: inline-block; animation: 5s ease 0s infinite normal none running mfm-twitch;\">🍮</span><style>@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}</style>"
  """
end
