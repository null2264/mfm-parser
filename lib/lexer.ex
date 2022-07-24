defmodule MfmParser.Lexer do
  alias MfmParser.Reader

  alias MfmParser.Token
  alias MfmParser.Token.MFM
  alias MfmParser.Token.Newline
  alias MfmParser.Token.Text

  def peek(input) do
    case next(input) do
      {token, _} -> token
      :eof -> :eof
    end
  end

  def next(input) do
    recursive_extract_next_token(Reader.next(input), get_empty_token(input))
  end

  defp recursive_extract_next_token(:eof, _) do
    :eof
  end

  defp recursive_extract_next_token({char, rest}, token) do
    if is_last_char_of_token?(char, rest, token) do
      {token |> Token.append(char), rest}
    else
      recursive_extract_next_token(Reader.next(rest), token |> Token.append(char))
    end
  end

  defp get_empty_token(input) do
    case Reader.peek(input) do
      :eof -> :eof
      "$" -> %MFM.Open{}
      "]" -> %MFM.Close{}
      "\n" -> %Newline{}
      _ -> %Text{}
    end
  end

  defp is_last_char_of_token?(char, _, %MFM.Open{}) do
    char == " "
  end

  defp is_last_char_of_token?(_, _, %MFM.Close{}) do
    true
  end

  defp is_last_char_of_token?(_, _, %Newline{}) do
    true
  end

  defp is_last_char_of_token?(_, rest, %Text{}) do
    case Reader.next(rest) do
      :eof -> true
      {"]", _} -> true
      {"$", new_rest} -> Reader.peek(new_rest) == "["
      _ -> false
    end
  end
end
