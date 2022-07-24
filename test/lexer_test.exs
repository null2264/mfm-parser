defmodule MfmParser.LexerTest do
  use ExUnit.Case

  alias MfmParser.Lexer

  alias MfmParser.Token.MFM
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
      assert Lexer.peek("$[ola puerca]") == %MFM.Open{content: "$[ola "}
      assert Lexer.next("$[ola puerca]") == {%MFM.Open{content: "$[ola "}, "puerca]"}

      assert Lexer.next("$[ola.x,speed=5s puerca]") ==
               {%MFM.Open{content: "$[ola.x,speed=5s "}, "puerca]"}
    end

    test "it doesn't crash if the token can't be completed" do
      Lexer.peek("$[ola")
      Lexer.next("$[ola")
    end
  end

  describe "] token" do
    test "it handles ] as a token" do
      assert Lexer.peek("]ve anime") == %MFM.Close{content: "]"}
      assert Lexer.next("]ve anime") == {%MFM.Close{content: "]"}, "ve anime"}
    end

    test "it works at the eof" do
      assert Lexer.peek("]") == %MFM.Close{content: "]"}
      assert Lexer.next("]") == {%MFM.Close{content: "]"}, ""}
    end
  end

  describe "text token" do
    test "it ends when a mfm token opens while a $ alone doesn't end the text token" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el $[spin culo]") ==
               %Text{content: "Tu abuela ve anime y no se lava el "}

      assert Lexer.next("Tu abuela ve anime y no se lava el $[spin culo]") ==
               {%Text{content: "Tu abuela ve anime y no se lava el "}, "$[spin culo]"}

      assert Lexer.peek("A $2 chocolatine") == %Text{content: "A $2 chocolatine"}
      assert Lexer.next("A $2 chocolatine") == {%Text{content: "A $2 chocolatine"}, ""}

      assert Lexer.peek("Eyes like $$") == %Text{content: "Eyes like $$"}
      assert Lexer.next("Eyes like $$") == {%Text{content: "Eyes like $$"}, ""}
    end

    test "it ends when a mfm token closes" do
      assert Lexer.peek("el culo]") == %Text{content: "el culo"}
      assert Lexer.next("el culo]") == {%Text{content: "el culo"}, "]"}
    end

    test "it ends when the eof is reached" do
      assert Lexer.peek("Tu abuela ve anime y no se lava el culo") == %Text{
               content: "Tu abuela ve anime y no se lava el culo"
             }

      assert Lexer.next("Tu abuela ve anime y no se lava el culo") ==
               {%Text{content: "Tu abuela ve anime y no se lava el culo"}, ""}
    end
  end

  describe "newline token" do
    test "it handles \n as a token" do
      assert Lexer.peek("\nchocolat") == %Newline{content: "\n"}
      assert Lexer.next("\nchocolat") == {%Newline{content: "\n"}, "chocolat"}
    end

    test "it works at the eof" do
      assert Lexer.peek("\n") == %Newline{content: "\n"}
      assert Lexer.next("\n") == {%Newline{content: "\n"}, ""}
    end
  end
end
