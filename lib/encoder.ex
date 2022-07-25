defmodule MfmParser.Encoder do
  alias MfmParser.Parser
  alias MfmParser.Node

  def to_html(tree) when is_list(tree) do
    {html, styles} = to_html_styles(tree)

    html |> append_styles_when_not_empty(styles)
  end

  def to_html(input) when is_binary(input) do
    Parser.parse(input) |> to_html()
  end

  defp to_html_styles(tree, _style \\ []) do
    tree
    |> Enum.reduce({"", []}, fn node, {html, styles} ->
      case node do
        %Node.Text{} ->
          {html <> node.props.text, styles}

        %Node.Newline{} ->
          {html <> node.props.text, styles}

        %Node.MFM.Flip{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          case node.props do
            %{v: true, h: true} ->
              {html <>
                 "<span style=\"display: inline-block; transform: scale(-1);\">#{html_child}</span>",
               styles}

            %{v: true} ->
              {html <>
                 "<span style=\"display: inline-block; transform: scaleY(-1);\">#{html_child}</span>",
               styles}

            _ ->
              {html <>
                 "<span style=\"display: inline-block; transform: scaleX(-1);\">#{html_child}</span>",
               styles ++ styles_child}
          end

        %Node.MFM.Font{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; font-family: #{node.props.font};\">#{html_child}</span>",
           styles ++ styles_child}

        %Node.MFM.X{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span font-size: \"#{node.props.size}\">#{html_child}</span>",
           styles ++ styles_child}

        %Node.MFM.Blur{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <> "<span class=\"_mfm_blur_\">#{html_child}</span>",
           styles ++
             [
               "._mfm_blur_ { filter: blur(6px); transition: filter .3s; } ._mfm_blur_:hover { filter: blur(0px); }"
             ] ++ styles_child}

        %Node.MFM.Jelly{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal both running mfm-rubberBand;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-rubberBand { 0% { transform:scaleZ(1) } 30% { transform:scale3d(1.25,.75,1) } 40% { transform:scale3d(.75,1.25,1) } 50% { transform:scale3d(1.15,.85,1) } 65% { transform:scale3d(.95,1.05,1) } 75% { transform:scale3d(1.05,.95,1) } to { transform:scaleZ(1) }}"
             ] ++ styles_child}

        %Node.MFM.Tada{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; font-size: 150%; animation: #{node.props.speed} linear 0s infinite normal both running tada;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes tada { 0% { transform: scaleZ(1); } 10%, 20% { transform: scale3d(.9,.9,.9) rotate3d(0,0,1,-3deg); } 30%, 50%, 70%, 90% { transform: scale3d(1.1,1.1,1.1) rotate3d(0,0,1,3deg); } 40%, 60%, 80% { transform: scale3d(1.1,1.1,1.1) rotate3d(0,0,1,-3deg); } 100% { transform: scaleZ(1); }}"
             ] ++ styles_child}

        %Node.MFM.Jump{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-jump;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-jump { 0% { transform:translateY(0) } 25% { transform:translateY(-16px) } 50% { transform:translateY(0) } 75% { transform:translateY(-8px) } to { transform:translateY(0) }}"
             ] ++ styles_child}

        %Node.MFM.Bounce{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-bounce; transform-origin: center bottom 0px;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-bounce { 0% { transform:translateY(0) scale(1) } 25% { transform:translateY(-16px) scale(1) }  50% { transform:translateY(0) scale(1) } 75% { transform:translateY(0) scale(1.5,.75) } to { transform:translateY(0) scale(1) }}"
             ] ++ styles_child}

        %Node.MFM.Spin{} ->
          {html_child, styles_child} = to_html_styles(node.children)

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

          directions_map = %{
            "left" => "reverse"
          }

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite #{Map.get(directions_map, node.props.direction, node.props.direction)} none running #{Map.get(keyframe_names_map, node.props.axis, "")};\">#{html_child}</span>",
           styles ++ [Map.get(styles_map, node.props.axis, "")] ++ styles_child}

        %Node.MFM.Shake{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-shake;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-shake { 0% { transform:translate(-3px,-1px) rotate(-8deg) } 5% { transform:translateY(-1px) rotate(-10deg) } 10% { transform:translate(1px,-3px) rotate(0) } 15% { transform:translate(1px,1px) rotate(11deg) } 20% { transform:translate(-2px,1px) rotate(1deg) } 25% { transform:translate(-1px,-2px) rotate(-2deg) } 30% { transform:translate(-1px,2px) rotate(-3deg) } 35% { transform:translate(2px,1px) rotate(6deg) } 40% { transform:translate(-2px,-3px) rotate(-9deg) } 45% { transform:translateY(-1px) rotate(-12deg) } 50% { transform:translate(1px,2px) rotate(10deg) } 55% { transform:translateY(-3px) rotate(8deg) } 60% { transform:translate(1px,-1px) rotate(8deg) } 65% { transform:translateY(-1px) rotate(-7deg) } 70% { transform:translate(-1px,-3px) rotate(6deg) } 75% { transform:translateY(-2px) rotate(4deg) } 80% { transform:translate(-2px,-1px) rotate(3deg) } 85% { transform:translate(1px,-3px) rotate(-10deg) } 90% { transform:translate(1px) rotate(3deg) } 95% { transform:translate(-2px) rotate(-3deg) } to { transform:translate(2px,1px) rotate(2deg) }}"
             ] ++ styles_child}

        %Node.MFM.Twitch{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} ease 0s infinite normal none running mfm-twitch;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}"
             ] ++ styles_child}

        %Node.MFM.Rainbow{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: #{node.props.speed} linear 0s infinite normal none running mfm-rainbow;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-rainbow { 0% { filter:hue-rotate(0deg) contrast(150%) saturate(150%) } to { filter:hue-rotate(360deg) contrast(150%) saturate(150%) }}"
             ] ++ styles_child}

        %Node.MFM.Sparkle{} ->
          # TODO: This is not how Misskey does it and should be changed to make it work like Misskey.
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;\">#{html_child}</span>",
           styles ++
             [
               "@keyframes mfm-sparkle { 0% { filter: brightness(100%) } to { filter: brightness(300%) }}"
             ] ++ styles_child}

        %Node.MFM.Rotate{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span style=\"display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;\">#{html_child}</span>",
           styles ++ styles_child}

        %Node.MFM.Undefined{} ->
          {html_child, styles_child} = to_html_styles(node.children)

          {html <>
             "<span>#{html_child}</span>", styles ++ styles_child}

        _ ->
          {html, styles}
      end
    end)
  end

  defp append_styles_when_not_empty(html, []) do
    html
  end

  defp append_styles_when_not_empty(html, styles) do
    styles = styles |> Enum.uniq() |> Enum.reduce("", fn style, acc -> style <> acc end)

    html <> "<style>" <> styles <> "</style>"
  end
end
