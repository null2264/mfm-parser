defmodule MfmParser.TokenTest do
  use ExUnit.Case

  alias MfmParser.Token

  test "it appends a character to the content" do
    assert %{content: "$[p"} = Token.append(%{content: "$["}, "p")
  end
end
