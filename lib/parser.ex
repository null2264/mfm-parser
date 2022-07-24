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
          parse(rest, tree)
        else
          case token do
            %Token.MFM.Open{} ->
              parse(rest, tree ++ [get_node(token)], fn token ->
                case token do
                  %Token.MFM.Close{} -> true
                  _ -> false
                end
              end)

            %Token.Text{} ->
              parse(
                rest,
                tree ++ [%Node.Text{props: %{text: token.content}}]
              )

            %Token.Newline{} ->
              parse(
                rest,
                tree ++ [%Node.Newline{props: %{text: token.content}}]
              )
          end
        end
    end
  end

  def get_node(token = %{content: content}) do
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

  #   def parse(input, tree \\ [], end_token \\ nil) do
  #     {:ok, token, rest} = MfmParser.Lexer.next(input)
  # 
  #     cond do
  #       # EOF
  #       token == "" ->
  #         {:ok, tree}
  # 
  #       # end_token reached
  #       token == end_token ->
  #         {:ok, tree, rest}
  # 
  #       # Newline
  #       Regex.match?(~r/<br>|\n/, token) ->
  #         new_tree = tree ++ [%{type: "newline"}]
  #         parse(rest, new_tree, end_token)
  # 
  #       # MFM $[ token
  #       Regex.match?(~r/\$\[/, token) ->
  #         {:ok, content, new_rest} = parse(rest, [], "]")
  # 
  #         new_tree =
  #           tree ++
  #             [
  #               %{
  #                 type: "mfm",
  #                 name: MfmParser.Parser.MFM.get_name_from_token(token),
  #                 content: content
  #               }
  #             ]
  # 
  #         parse(new_rest, new_tree, end_token)
  # 
  #       # HTML token
  #       Regex.match?(~r/<.*>/, token) ->
  #         new_end_token = MfmParser.Parser.HTML.get_end_token(token)
  # 
  #         {:ok, content, new_rest} = parse(rest, [], new_end_token)
  # 
  #         new_tree =
  #           tree ++
  #             [
  #               %{
  #                 type: "html",
  #                 name: MfmParser.Parser.HTML.get_name_from_token(token),
  #                 attributes: MfmParser.Parser.HTML.get_attributes_from_token(token),
  #                 content: content
  #               }
  #             ]
  # 
  #         parse(new_rest, new_tree, end_token)
  # 
  #       # Regular text
  #       true ->
  #         new_tree = tree ++ [%{type: "text", content: token}]
  #         parse(rest, new_tree, end_token)
  #     end
  #   end
end
