defmodule MfmParser.ReaderTest do
  use ExUnit.Case
  alias MfmParser.Reader

  test "it can peek at the next character" do
    assert Reader.peek("chocolatine") == "c"
  end

  test "it can peek at the nth character" do
    assert Reader.peek("chocolatine", 7) == "a"
  end

  test "it step to the next character" do
    assert Reader.next("chocolatine") == {"c", "hocolatine"}
  end

  test "it returns eof" do
    assert Reader.peek("") == :eof
    assert Reader.peek("", 1) == :eof
    assert Reader.peek("", 2) == :eof
    assert Reader.peek("c", 3) == :eof
    assert Reader.next("") == :eof
  end
end
