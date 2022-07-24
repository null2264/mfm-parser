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
      true -> %Node.MFM.Undefined{}
    end
    |> fill_props(token)
  end

  defp fill_props(node = %{props: props}, %{content: content}) do
    new_props = props |> Map.merge(Token.MFM.to_props(content))

    node |> Map.merge(%{props: new_props})
  end
end
