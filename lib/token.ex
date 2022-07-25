defmodule MfmParser.Token do
  def append(token = %{content: content}, new_char) do
    token |> Map.put(:content, content <> new_char)
  end
end

defmodule MfmParser.Token.Text do
  defstruct content: ""
end

defmodule MfmParser.Token.Newline do
  defstruct content: ""
end

defmodule MfmParser.Token.MFM.Open do
  defstruct content: ""
end

defmodule MfmParser.Token.MFM.Close do
  defstruct content: ""
end
