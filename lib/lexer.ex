defmodule MfmParser.Lexer do
  alias MfmParser.Reader

  def peek(input) do
    case next(input) do
      {:ok, token, _} -> {:ok, token}
      :eof -> :eof
    end
  end

  def next(input) do
    recursive_next(Reader.next(input), "", type_of_token(input))
  end

  defp recursive_next(:eof, _, _) do
    :eof
  end

  defp recursive_next({:ok, char, rest}, part, token_type) do
    if is_end_of_token?(char, rest, token_type) do
      {:ok, part <> char, rest}
    else
      recursive_next(Reader.next(rest), part <> char, token_type)
    end
  end

  defp is_end_of_token?(char, _, :mfm_open) do
    char in [" "]
  end

  defp is_end_of_token?(_, _, :mfm_close) do
    true
  end

  defp is_end_of_token?(_, _, :newline) do
    true
  end

  defp is_end_of_token?(_, rest, :text) do
    case Reader.next(rest) do
      :eof -> true
      {:ok, "]", _} -> true
      {:ok, "$", new_rest} -> Reader.peek(new_rest) == {:ok, "["}
      _ -> false
    end
  end

  defp type_of_token(input) do
    case Reader.peek(input) do
      :eof -> :eof
      {:ok, "$"} -> :mfm_open
      {:ok, "]"} -> :mfm_close
      {:ok, "\n"} -> :newline
      _ -> :text
    end
  end
end
