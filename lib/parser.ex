defmodule MfmParser.Parser do
  alias MfmParser.Token
  alias MfmParser.Node
  alias MfmParser.Lexer

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
              {children, rest} = parse(rest, [], &is_mfm_close_token?/1)

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
      content =~ "$[flip" -> %Node.MFM.Flip{} |> fill_props(token)
      content =~ "$[font" -> %Node.MFM.Font{} |> fill_props(token)
      content =~ "$[x" -> %Node.MFM.X{} |> fill_props(token)
      content =~ "$[blur" -> %Node.MFM.Blur{} |> fill_props(token)
      content =~ "$[jelly" -> %Node.MFM.Jelly{} |> fill_props(token)
      content =~ "$[tada" -> %Node.MFM.Tada{} |> fill_props(token)
      content =~ "$[jump" -> %Node.MFM.Jump{} |> fill_props(token)
      content =~ "$[bounce" -> %Node.MFM.Bounce{} |> fill_props(token)
      content =~ "$[spin" -> %Node.MFM.Spin{} |> fill_props(token)
      content =~ "$[shake" -> %Node.MFM.Shake{} |> fill_props(token)
      content =~ "$[twitch" -> %Node.MFM.Twitch{} |> fill_props(token)
      content =~ "$[rainbow" -> %Node.MFM.Rainbow{} |> fill_props(token)
      content =~ "$[sparkle" -> %Node.MFM.Sparkle{} |> fill_props(token)
      content =~ "$[rotate" -> %Node.MFM.Rotate{} |> fill_props(token)
      true -> %Node.MFM.Undefined{} |> fill_props(token)
    end
  end

  defp fill_props(node = %{props: props}, %{content: content}) do
    new_props = props |> Map.merge(Token.MFM.to_props(content))

    node |> Map.merge(%{props: new_props})
  end
end
