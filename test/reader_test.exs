defmodule MfmParser.ReaderTest do
  use ExUnit.Case
  alias MfmParser.Reader

  test "it can peek at the next character" do
    assert Reader.peek("chocolatine") == "c"
  end

  test "it step to the next character" do
    assert Reader.next("chocolatine") == {"c", "hocolatine"}
  end

  test "it returns eof" do
    assert Reader.peek("") == :eof
    assert Reader.next("") == :eof
  end
end
