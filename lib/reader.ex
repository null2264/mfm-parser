defmodule MfmParser.Reader do
  def peek(input) do
    next_char = input |> String.first()

    case next_char do
      nil -> :eof
      _ -> {:ok, next_char}
    end
  end

  def next(input) do
    {next_char, rest} = String.split_at(input, 1)

    case next_char do
      "" -> :eof
      _ -> {:ok, next_char, rest}
    end
  end
end
