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
