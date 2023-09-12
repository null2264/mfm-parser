defmodule MfmParser.Encoder do
  alias MfmParser.Parser
  alias MfmParser.Node

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
    {html, content, _styles, _start_tag, _end_tag} = to_html_styles(tree, true)

    html <> content
  end

  def to_html(input) when is_binary(input) do
    Parser.parse(input) |> to_html()
  end

  defp to_html_styles(tree, is_root \\ false) do
    tree
    |> Enum.reduce({"", "", [], "", ""}, fn node, {root, content, styles, start_tag, end_tag} ->
      case node do
        %Node.Text{} ->
          if (root == "" && is_root) do
            {root <> node.props.text, content, styles, "", ""}
          else
            {root, start_tag <> content <> end_tag <> node.props.text, styles, "", ""}
          end

        %Node.Newline{} ->
          {root, content <> node.props.text, styles, "", ""}

        %Node.MFM.Flip{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          case node.props do
            %{v: true, h: true} ->
              {root,
                content <> "<span class=\"mfm _mfm_flip_\" style=\"display: inline-block; transform: scale(-1);\">#{html_child}</span>",
                styles,
                start_tag_child, end_tag_child}

            %{v: true} ->
              {root,
                content <> "<span class=\"mfm _mfm_flipV_\" style=\"display: inline-block; transform: scaleY(-1);\">#{html_child}</span>",
                styles,
                start_tag_child, end_tag_child}

            _ ->
              {root,
                content <> "<span class=\"mfm _mfm_flipH_\" style=\"display: inline-block; transform: scaleX(-1);\">#{html_child}</span>",
                styles ++ styles_child, start_tag_child, end_tag_child}
          end

        %Node.MFM.Font{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm\" style=\"display: inline-block; font-family: #{node.props.font};\">#{html_child}</span>",
            styles ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.X{} ->
          prop_map = %{"200%" => "2", "400%" => "3", "600%" => "4"}
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span style=\"font-size: #{node.props.size}\" class=\"mfm _mfm_x#{prop_map[node.props.size]}_\">#{html_child}</span>",
            styles ++ styles_child, start_tag_child, end_tag_child}

        %Node.MFM.Blur{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm _mfm_blur_\">#{html_child}</span>",
            styles ++
              [
                "._mfm_blur_ { filter: blur(6px); transition: filter .3s; } ._mfm_blur_:hover { filter: blur(0px); }"
              ] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Jelly{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root, content <> "<span class=\"mfm _mfm_jelly_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal both running mfm-rubberBand;\">#{html_child}</span>", styles_child, start_tag_child, end_tag_child}

        %Node.MFM.Tada{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm _mfm_tada_\" style=\"display: inline-block; font-size: 150%; animation: #{node.props.speed} linear 0s infinite normal both running mfm-tada;\">#{html_child}</span>",
            styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Jump{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root, content <> "<span class=\"mfm _mfm_jump_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-jump;\">#{html_child}</span>", styles_child, start_tag_child, end_tag_child}

        %Node.MFM.Bounce{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root, content <> "<span class=\"mfm _mfm_bounce_\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-bounce; transform-origin: center bottom 0px;\">#{html_child}</span>", styles_child, start_tag_child, end_tag_child}

        %Node.MFM.Spin{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          styles_map = %{
            "x" =>
              "@keyframes mfm-spinX { 0% { transform:perspective(128px) rotateX(0) } to { transform:perspective(128px) rotateX(360deg) }}",
            "y" =>
              "@keyframes mfm-spinY { 0% { transform:perspective(128px) rotateY(0) } to { transform:perspective(128px) rotateY(360deg) }}",
            "z" =>
              "@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}"
          }

          keyframe_names_map = %{
            "x" => "mfm-spinX",
            "y" => "mfm-spinY",
            "z" => "mfm-spin"
          }

          classes_map = %{
            "x" => "_mfm_spinX_",
            "y" => "_mfm_spinY_"
          }

          directions_map = %{
              "left" => "reverse"
          }

          {root,
            content <> "<span class=\"mfm #{Map.get(classes_map, node.props.axis, "_mfm_spin_")}\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite #{Map.get(directions_map, node.props.direction, node.props.direction)} none running #{Map.get(keyframe_names_map, node.props.axis, "")};\">#{html_child}</span>",
            styles ++ [Map.get(styles_map, node.props.axis, "")] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Shake{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm\" style=\"display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-shake;\">#{html_child}</span>",
            styles ++
              [
                "@keyframes mfm-shake { 0% { transform:translate(-3px,-1px) rotate(-8deg) } 5% { transform:translateY(-1px) rotate(-10deg) } 10% { transform:translate(1px,-3px) rotate(0) } 15% { transform:translate(1px,1px) rotate(11deg) } 20% { transform:translate(-2px,1px) rotate(1deg) } 25% { transform:translate(-1px,-2px) rotate(-2deg) } 30% { transform:translate(-1px,2px) rotate(-3deg) } 35% { transform:translate(2px,1px) rotate(6deg) } 40% { transform:translate(-2px,-3px) rotate(-9deg) } 45% { transform:translateY(-1px) rotate(-12deg) } 50% { transform:translate(1px,2px) rotate(10deg) } 55% { transform:translateY(-3px) rotate(8deg) } 60% { transform:translate(1px,-1px) rotate(8deg) } 65% { transform:translateY(-1px) rotate(-7deg) } 70% { transform:translate(-1px,-3px) rotate(6deg) } 75% { transform:translateY(-2px) rotate(4deg) } 80% { transform:translate(-2px,-1px) rotate(3deg) } 85% { transform:translate(1px,-3px) rotate(-10deg) } 90% { transform:translate(1px) rotate(3deg) } 95% { transform:translate(-2px) rotate(-3deg) } to { transform:translate(2px,1px) rotate(2deg) }}"
              ] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Twitch{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm\" style=\"display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-twitch;\">#{html_child}</span>",
            styles ++
              [
                "@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}"
              ] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Rainbow{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm\" style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-rainbow;\">#{html_child}</span>",
            styles ++
              [
                "@keyframes mfm-rainbow { 0% { filter:hue-rotate(0deg) contrast(150%) saturate(150%) } to { filter:hue-rotate(360deg) contrast(150%) saturate(150%) }}"
              ] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Sparkle{} ->
          # TODO: This is not how Misskey does it and should be changed to make it work like Misskey.
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            "<span class=\"mfm\" style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;\">#{html_child}</span>",
            styles ++
              [
                "@keyframes mfm-sparkle { 0% { filter: brightness(100%) } to { filter: brightness(300%) }}"
              ] ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Rotate{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root,
            content <> "<span class=\"mfm\" style=\"display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;\">#{html_child}</span>",
            styles ++ styles_child,
            start_tag_child, end_tag_child}

        %Node.MFM.Center{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root, html_child, styles ++ styles_child, "#{content}<p class=\"center\">" <> start_tag_child, end_tag_child <> "</p>"}

        %Node.MFM.Undefined{} ->
          {_root, html_child, styles_child, start_tag_child, end_tag_child} = to_html_styles(node.children)

          {root, content <> "<span>#{html_child}</span>", styles ++ styles_child, start_tag_child, end_tag_child}

        _ ->
          {root, content, styles, start_tag, end_tag}
      end
    end)
  end
end
