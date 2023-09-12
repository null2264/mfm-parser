defmodule MfmParser.Parser do
  alias MfmParser.Token
  alias MfmParser.Node
  alias MfmParser.Lexer

  @moduledoc """
  `MfmParser` is a parser for [Misskey Flavoured Markdown](https://mk.nixnet.social/mfm-cheat-sheet).

  It can parse MFM and return a tree. It also has an encoder who can turn a tree into HTML.

  It only works for the MFM specific tags of the form $[name.opts content].

  Other parts of MFM (html, Markdown and [KaTeX](https://katex.org/)) are out of scope for this project.

  ## Examples

      iex> MfmParser.Parser.parse("$[twitch.speed=5s 🍮]")
      [
        %MfmParser.Node.MFM.Twitch{
          children: [%MfmParser.Node.Text{props: %{text: "🍮"}}],
          props: %{speed: "5s"}
        }
      ]
  """

  def parse(input, tree \\ [], is_end_token \\ fn _ -> false end) do
    case Lexer.next(input) do
      :eof ->
        tree

      {token, rest} ->
        if is_end_token.(token) do
          {tree, rest}
        else
          case token do
            %Token.MFM.Open{} ->
              {children, rest} =
                case parse(rest, [], &is_mfm_close_token?/1) do
                  {children, rest} ->
                    {children, rest}

                  _ ->
                    {[], rest}
                end

              parse(
                rest,
                tree ++ [token |> get_node() |> Map.put(:children, children)],
                is_end_token
              )

            %Token.Text{} ->
              parse(
                rest,
                tree ++ [%Node.Text{props: %{text: token.content}}],
                is_end_token
              )

            %Token.Newline{} ->
              parse(
                rest,
                tree ++ [%Node.Newline{props: %{text: token.content}}],
                is_end_token
              )

            %Token.MFM.Close{} ->
              parse(
                rest,
                tree ++ [%Node.Text{props: %{text: token.content}}],
                is_end_token
              )
          end
        end
    end
  end

  defp is_mfm_close_token?(token) do
    case token do
      %Token.MFM.Close{} -> true
      _ -> false
    end
  end

  defp get_node(token = %{content: content}) do
    cond do
      content =~ "$[flip" -> %Node.MFM.Flip{}
      content =~ "$[font" -> %Node.MFM.Font{}
      content =~ "$[x" -> %Node.MFM.X{}
      content =~ "$[blur" -> %Node.MFM.Blur{}
      content =~ "$[jelly" -> %Node.MFM.Jelly{}
      content =~ "$[tada" -> %Node.MFM.Tada{}
      content =~ "$[jump" -> %Node.MFM.Jump{}
      content =~ "$[bounce" -> %Node.MFM.Bounce{}
      content =~ "$[spin" -> %Node.MFM.Spin{}
      content =~ "$[shake" -> %Node.MFM.Shake{}
      content =~ "$[twitch" -> %Node.MFM.Twitch{}
      content =~ "$[rainbow" -> %Node.MFM.Rainbow{}
      content =~ "$[sparkle" -> %Node.MFM.Sparkle{}
      content =~ "$[rotate" -> %Node.MFM.Rotate{}
      content =~ "$[center" -> %Node.MFM.Center{}
      true -> %Node.MFM.Undefined{}
    end
    |> fill_props(token)
  end

  defp fill_props(node = %{props: props}, %{content: content}) do
    new_props = props |> Map.merge(to_props(content))

    node |> Map.merge(%{props: new_props})
  end

  def to_props(opts_string) when is_binary(opts_string) do
    cond do
      opts_string =~ "." ->
        Regex.replace(~r/^.*?\./u, opts_string, "")
        |> String.trim()
        |> String.split(",")
        |> Enum.reduce(%{}, fn opt, acc ->
          acc
          |> Map.merge(
            cond do
              opt =~ "speed" ->
                %{speed: String.replace(opt, "speed=", "")}

              opt =~ "v" ->
                %{v: true}

              opt =~ "h" ->
                %{h: true}

              opt =~ "x" ->
                %{axis: "x"}

              opt =~ "y" ->
                %{axis: "y"}

              opt =~ "left" ->
                %{direction: "left"}

              opt =~ "alternate" ->
                %{direction: "alternate"}

              true ->
                if Regex.match?(~r/^\$\[font/, opts_string) do
                  %{font: opt}
                else
                  %{}
                end
            end
          )
        end)

      opts_string =~ "$[x" ->
        %{
          size:
            case opts_string |> String.replace("$[x", "") |> String.trim() do
              "2" -> "200%"
              "3" -> "400%"
              "4" -> "600%"
              _ -> "100%"
            end
        }

      true ->
        %{}
    end
  end
end
