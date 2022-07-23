defmodule MfmParser.LexerTest do
  use ExUnit.Case

  alias MfmParser.Lexer

  alias MfmParser.Token.MFMOpen
  alias MfmParser.Token.MFMClose
  alias MfmParser.Token.Newline
  alias MfmParser.Token.Text

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
      assert Lexer.peek("$[ola puerca]") == {:ok, %MFMOpen{content: "$[ola "}}
      assert Lexer.next("$[ola puerca]") == {:ok, %MFMOpen{content: "$[ola "}, "puerca]"}

      assert Lexer.next("$[ola.x,speed=5s puerca]") ==
               {:ok, %MFMOpen{content: "$[ola.x,speed=5s "}, "puerca]"}
    end

    test "it doesn't crash if the token can't be completed" do
      Lexer.peek("$[ola")
      Lexer.next("$[ola")
    end
  end

  describe "] token" do
    test "it handles ] as a token" do
      assert Lexer.peek("]ve anime") == {:ok, %MFMClose{content: "]"}}
      assert Lexer.next("]ve anime") == {:ok, %MFMClose{content: "]"}, "ve anime"}
    end

    test "it works at the eof" do
      assert Lexer.peek("]") == {:ok, %MFMClose{content: "]"}}
      assert Lexer.next("]") == {:ok, %MFMClose{content: "]"}, ""}
    end
  end

  describe "text token" do
    test "it ends when a mfm token opens while a $ alone doesn't end the text token" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el $[spin culo]") ==
               {:ok, %Text{content: "Tu abuela ve anime y no se lava el "}}

      assert Lexer.next("Tu abuela ve anime y no se lava el $[spin culo]") ==
               {:ok, %Text{content: "Tu abuela ve anime y no se lava el "}, "$[spin culo]"}

      assert Lexer.peek("A $2 chocolatine") == {:ok, %Text{content: "A $2 chocolatine"}}
      assert Lexer.next("A $2 chocolatine") == {:ok, %Text{content: "A $2 chocolatine"}, ""}

      assert Lexer.peek("Eyes like $$") == {:ok, %Text{content: "Eyes like $$"}}
      assert Lexer.next("Eyes like $$") == {:ok, %Text{content: "Eyes like $$"}, ""}
    end

    test "it ends when a mfm token closes" do
      assert Lexer.peek("el culo]") == {:ok, %Text{content: "el culo"}}
      assert Lexer.next("el culo]") == {:ok, %Text{content: "el culo"}, "]"}
    end

    test "it ends when the eof is reached" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el culo") ==
               {:ok, %Text{content: "Tu abuela ve anime y no se lava el culo"}}

      assert Lexer.next("Tu abuela ve anime y no se lava el culo") ==
               {:ok, %Text{content: "Tu abuela ve anime y no se lava el culo"}, ""}
    end
  end

  describe "newline token" do
    test "it handles \n as a token" do
      assert Lexer.peek("\nchocolat") == {:ok, %Newline{content: "\n"}}
      assert Lexer.next("\nchocolat") == {:ok, %Newline{content: "\n"}, "chocolat"}
    end

    test "it works at the eof" do
      assert Lexer.peek("\n") == {:ok, %Newline{content: "\n"}}
      assert Lexer.next("\n") == {:ok, %Newline{content: "\n"}, ""}
    end
  end
end
