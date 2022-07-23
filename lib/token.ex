defmodule MfmParser.Token do
  def append(token = %{content: content}, new_char) do
    token |> Map.put(:content, content <> new_char)
  end
end
