defmodule MfmParser.Encoder do
  alias MfmParser.Parser
  alias MfmParser.Node
  import Temple

  @moduledoc """
  An encoder who can turn a tree into HTML. 

  It only works for the MFM specific tags of the form $[name.opts content]. 

  Other parts of MFM (html, Markdown and [KaTeX](https://katex.org/)) are out of scope for this project. 

  It can directly take input from function `MfmParser.Parser.parse`. 

  ## Examples

      iex> [
      ...>   %MfmParser.Node.MFM.Twitch{
      ...>     children: [%MfmParser.Node.Text{props: %{text: "🍮"}}],
      ...>     props: %{speed: "5s"}
      ...>   }
      ...> ]
      ...> |> MfmParser.Encoder.to_html()
      "<span class=\\"mfm\\" style=\\"display: inline-block; animation: 5s ease 0s infinite normal none running mfm-twitch;\\">🍮</span>"

      iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]") |> MfmParser.Encoder.to_html()
      "<span class=\\"mfm\\" style=\\"display: inline-block; animation: 5s ease 0s infinite normal none running mfm-twitch;\\">🍮</span>"
  """

  def to_html(tree) when is_list(tree) do
    to_html_styles(tree)
  end

  def to_html(input) when is_binary(input) do
    Parser.parse(input) |> to_html()
  end

  defp to_html_styles(tree) do
    tree
    |> Enum.reduce("", fn node, html ->
      html <>
        case node do
          %Node.Text{} ->
            node.props.text

          %Node.Newline{} ->
            node.props.text

          %Node.MFM.Flip{} ->
            html_child = to_html_styles(node.children)

            case node.props do
              %{v: true, h: true} ->
                temple do
                  span class: "mfm", style: "display: inline-block; transform: scale(-1);" do
                    html_child
                  end
                end

              %{v: true} ->
                "<span class=\"mfm\" style=\"display: inline-block; transform: scaleY(-1);\">#{html_child}</span>"

              _ ->
                "<span class=\"mfm\" style=\"display: inline-block; transform: scaleX(-1);\">#{html_child}</span>"
            end

          %Node.MFM.Font{} ->
            html_child = to_html_styles(node.children)

            temple do
              span class: "mfm",
                   style: "display: inline-block; font-family: #{node.props.font};" do
                html_child
              end
            end

          %Node.MFM.X{} ->
            html_child = to_html_styles(node.children)
            prop_map = %{"200%" => "2", "400%" => "3", "600%" => "4"}

            temple do
              span style: "font-size: #{node.props.size}", class: "mfm _mfm_x#{prop_map[node.props.size]}_" do
                html_child
              end
            end

          %Node.MFM.Blur{} ->
            html_child = to_html_styles(node.children)

            temple do
              span(class: "mfm _mfm_blur_", do: html_child)
            end

          %Node.MFM.Jelly{} ->
            html_child = to_html_styles(node.children)

            "<span class=\"mfm _mfm_jelly_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal both running mfm-rubberBand;\">#{html_child}</span>"

          %Node.MFM.Tada{} ->
            html_child = to_html_styles(node.children)

            temple do
              span class: "mfm _mfm_tada_",
                   style:
                     "display: inline-block; font-size: 150%; animation: #{node.props.speed} linear 0s infinite normal both running mfm-tada;" do
                html_child
              end
            end

          %Node.MFM.Jump{} ->
            html_child = to_html_styles(node.children)

            "<span class=\"mfm _mfm_jump_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-jump;\">#{html_child}</span>"

          %Node.MFM.Bounce{} ->
            html_child = to_html_styles(node.children)

            "<span class=\"mfm _mfm_bounce_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-bounce; transform-origin: center bottom 0px;\">#{html_child}</span>"

          %Node.MFM.Spin{} ->
            html_child = to_html_styles(node.children)

            keyframe_names_map = %{
              "x" => "mfm-spinX",
              "y" => "mfm-spinY",
              "z" => "mfm-spin"
            }

            directions_map = %{
              "left" => "reverse"
            }

            "<span class=\"mfm _mfm_spin_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite #{Map.get(directions_map, node.props.direction, node.props.direction)} none running #{Map.get(keyframe_names_map, node.props.axis, "")};\">#{html_child}</span>"

          %Node.MFM.Shake{} ->
            html_child = to_html_styles(node.children)

            temple do
              span class: "mfm",
                   style:
                     "display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-shake;" do
                html_child
              end
            end

          %Node.MFM.Twitch{} ->
            html_child = to_html_styles(node.children)

            temple do
              span class: "mfm",
                   style:
                     "display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-twitch;" do
                html_child
              end
            end

          %Node.MFM.Rainbow{} ->
            html_child = to_html_styles(node.children)

            "<span class=\"mfm\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-rainbow;\">#{html_child}</span>"

          %Node.MFM.Sparkle{} ->
            # TODO: This is not how Misskey does it and should be changed to make it work like Misskey.
            html_child = to_html_styles(node.children)

            "<span class=\"mfm\" style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;\">#{html_child}</span>"

          %Node.MFM.Rotate{} ->
            html_child = to_html_styles(node.children)

            "<span class=\"mfm\" style=\"display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;\">#{html_child}</span>"

          %Node.MFM.Undefined{} ->
            html_child = to_html_styles(node.children)

            "<span>#{html_child}</span>"

          _ ->
            html
        end
    end)
  end
end
