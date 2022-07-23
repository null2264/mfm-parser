defmodule MfmParser.LexerTest do
  use ExUnit.Case
  alias MfmParser.Lexer

  describe "eof" do
    test "peek/1 handles eof" do
      assert Lexer.peek("") == :eof
    end

    test "next/1 handles eof" do
      assert Lexer.next("") == :eof
    end
  end

  describe "mfm $[ token" do
    test "it ends with a space" do
      assert Lexer.peek("$[ola puerca]") == {:ok, "$[ola "}
      assert Lexer.next("$[ola puerca]") == {:ok, "$[ola ", "puerca]"}
      assert Lexer.next("$[ola.x,speed=5s puerca]") == {:ok, "$[ola.x,speed=5s ", "puerca]"}
    end

    test "it doesn't crash if the token can't be completed" do
      Lexer.peek("$[ola")
      Lexer.next("$[ola")
    end
  end

  describe "] token" do
    test "it handles ] as a token" do
      assert Lexer.peek("]ve anime") == {:ok, "]"}
      assert Lexer.next("]ve anime") == {:ok, "]", "ve anime"}
    end

    test "it works at the eof" do
      assert Lexer.peek("]") == {:ok, "]"}
      assert Lexer.next("]") == {:ok, "]", ""}
    end
  end

  describe "text token" do
    test "it ends when a mfm token opens while a $ alone doesn't end the text token" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el $[spin culo]") ==
               {:ok, "Tu abuela ve anime y no se lava el "}

      assert Lexer.next("Tu abuela ve anime y no se lava el $[spin culo]") ==
               {:ok, "Tu abuela ve anime y no se lava el ", "$[spin culo]"}

      assert Lexer.peek("A $2 chocolatine") == {:ok, "A $2 chocolatine"}
      assert Lexer.next("A $2 chocolatine") == {:ok, "A $2 chocolatine", ""}

      assert Lexer.peek("Eyes like $$") == {:ok, "Eyes like $$"}
      assert Lexer.next("Eyes like $$") == {:ok, "Eyes like $$", ""}
    end

    test "it ends when a mfm token closes" do
      assert Lexer.peek("el culo]") == {:ok, "el culo"}
      assert Lexer.next("el culo]") == {:ok, "el culo", "]"}
    end

    test "it ends when the eof is reached" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el culo") ==
               {:ok, "Tu abuela ve anime y no se lava el culo"}

      assert Lexer.next("Tu abuela ve anime y no se lava el culo") ==
               {:ok, "Tu abuela ve anime y no se lava el culo", ""}
    end
  end

  describe "newline token" do
    test "it handles \n as a token" do
      assert Lexer.peek("\nchocolat") == {:ok, "\n"}
      assert Lexer.next("\nchocolat") == {:ok, "\n", "chocolat"}
    end

    test "it works at the eof" do
      assert Lexer.peek("\n") == {:ok, "\n"}
      assert Lexer.next("\n") == {:ok, "\n", ""}
    end
  end
end
