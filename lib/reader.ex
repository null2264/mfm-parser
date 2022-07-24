defmodule MfmParser.Reader do
  def peek(input) do
    next_char = input |> String.first()

    case next_char do
      nil -> :eof
      _ -> next_char
    end
  end

  def peek(input, steps) do
    nth_char = input |> String.at(steps - 1)

    case nth_char do
      nil -> :eof
      _ -> nth_char
    end
  end

  def next(input) do
    {next_char, rest} = String.split_at(input, 1)

    case next_char do
      "" -> :eof
      _ -> {next_char, rest}
    end
  end
end
